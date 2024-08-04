import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class NowplayingMoviePage extends StatefulWidget {
  const NowplayingMoviePage({super.key});

  @override
  State<NowplayingMoviePage> createState() => _NowplayingMoviePageState();
}

class _NowplayingMoviePageState extends State<NowplayingMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NowPlayingMovieBloc>().add(FetchNowPlayingMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
          builder: (_, state) {
            if (state.state == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.state == RequestState.Loaded) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (_, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
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
