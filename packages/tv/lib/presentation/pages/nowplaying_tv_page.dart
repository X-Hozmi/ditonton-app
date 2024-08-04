import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class NowplayingTVPage extends StatefulWidget {
  const NowplayingTVPage({super.key});

  @override
  State<NowplayingTVPage> createState() => _NowplayingTVPageState();
}

class _NowplayingTVPageState extends State<NowplayingTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingTVBloc>().add(FetchNowPlayingTV()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Serial TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTVBloc, NowPlayingTVState>(
          builder: (_, state) {
            if (state.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tv[index];
                  return TVCard(tv);
                },
                itemCount: state.tv.length,
              );
            } else if (state.state == RequestState.Error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else if (state.state == RequestState.Empty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.question_mark, size: 72),
                    const SizedBox(height: 2),
                    Text('Empty data', style: kSubtitle),
                  ],
                ),
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
    );
  }
}
