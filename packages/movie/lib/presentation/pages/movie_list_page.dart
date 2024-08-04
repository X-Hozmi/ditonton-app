import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/utils/routes.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(FetchNowPlayingMovies());
      context.read<PopularMovieBloc>().add(FetchPopularMovies());
      context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cari Film',
                style: kHeading5.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                key: const Key('searchBar'),
                onTap: () {
                  Navigator.pushNamed(context, SEARCH_ROUTE);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF211F30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16).copyWith(right: 20),
                        child: const Icon(Icons.search),
                      ),
                      Text(
                        'Spongebob Squarepants',
                        style: kBodyText.copyWith(
                          fontSize: 14,
                          color: const Color(0xFFBBBBBB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubHeading(
                        title: 'Daftar Film',
                        onTap: () => Navigator.pushNamed(
                            context, NOW_PLAYING_MOVIE_ROUTE),
                      ),
                      BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                        builder: (context, state) {
                          if (state.state == RequestState.Loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == RequestState.Loaded) {
                            return MovieList(state.movies);
                          } else {
                            return const Text('Gagal');
                          }
                        },
                      ),
                      _buildSubHeading(
                        title: 'Film Populer',
                        onTap: () =>
                            Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE),
                      ),
                      BlocBuilder<PopularMovieBloc, PopularMovieState>(
                        builder: (context, state) {
                          if (state.state == RequestState.Loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == RequestState.Loaded) {
                            return MovieList(state.movies);
                          } else {
                            return const Text('Gagal');
                          }
                        },
                      ),
                      _buildSubHeading(
                        title: 'Film Top Rating',
                        onTap: () => Navigator.pushNamed(
                            context, TOP_RATED_MOVIES_ROUTE),
                      ),
                      BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
                        builder: (context, state) {
                          if (state.state == RequestState.Loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == RequestState.Loaded) {
                            return MovieList(state.movies);
                          } else {
                            return const Text('Gagal');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({
    required String title,
    required Function() onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Lebih Banyak'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
