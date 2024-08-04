import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/list/list_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  test('initial state should be MovieListState.initial()', () {
    expect(movieListBloc.state, MovieListState.initial());
  });

  final tMovieList = <Movie>[testMovie];

  group('Now Playing Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        MovieListState.initial().copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
        ),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        MovieListState.initial().copyWith(nowPlayingState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(nowPlayingState: RequestState.Loading),
        MovieListState.initial().copyWith(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingMovies.execute()),
      ],
    );
  });

  group('Popular Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(popularMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMovieList,
        ),
      ],
      verify: (_) => [
        verify(mockGetPopularMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(popularMoviesState: RequestState.Loading),
        MovieListState.initial()
            .copyWith(popularMoviesState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetPopularMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(popularMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          popularMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetPopularMovies.execute()),
      ],
    );
  });

  group('Top Rated Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(topRatedMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
      verify: (_) => [
        verify(mockGetTopRatedMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(topRatedMoviesState: RequestState.Loading),
        MovieListState.initial()
            .copyWith(topRatedMoviesState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetTopRatedMovies.execute()),
      ],
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        MovieListState.initial()
            .copyWith(topRatedMoviesState: RequestState.Loading),
        MovieListState.initial().copyWith(
          topRatedMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetTopRatedMovies.execute()),
      ],
    );
  });
}
