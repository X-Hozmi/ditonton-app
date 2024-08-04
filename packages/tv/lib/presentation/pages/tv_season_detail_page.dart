import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/season/season_bloc.dart';
import 'package:core/presentation/widgets/tv_episode_card_list.dart';
import 'package:flutter/material.dart';

class TVSeasonDetailPage extends StatefulWidget {
  final int id;
  final int seasonNumber;

  const TVSeasonDetailPage({
    super.key,
    required this.id,
    required this.seasonNumber,
  });

  @override
  State<TVSeasonDetailPage> createState() => _TVSeasonDetailPageState();
}

class _TVSeasonDetailPageState extends State<TVSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<TVSeasonDetailBloc>()
          .add(FetchTVSeasonDetail(widget.id, widget.seasonNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TVSeasonDetailBloc, TVSeasonDetailState>(
          builder: (_, state) {
            if (state.seasonState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.seasonState == RequestState.Loaded) {
              final season = state.seasonDetail;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    season!.name,
                    style: kHeading6.copyWith(fontSize: 18),
                  ),
                  Text(
                    '${season.episodes.length} Episodes',
                    style: kSubtitle.copyWith(fontSize: 14),
                  ),
                ],
              );
            } else {
              return const Text('Error loading season details');
            }
          },
        ),
      ),
      body: BlocBuilder<TVSeasonDetailBloc, TVSeasonDetailState>(
        builder: (context, state) {
          if (state.seasonState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.seasonState == RequestState.Loaded) {
            final episodes = state.seasonDetail?.episodes ?? [];
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: episodes.length,
              itemBuilder: (_, index) {
                final episode = episodes[index];
                return EpisodeCardList(episode: episode);
              },
            );
          } else {
            return Center(child: Text(state.message));
          }
        },
      ),
    );
  }
}
