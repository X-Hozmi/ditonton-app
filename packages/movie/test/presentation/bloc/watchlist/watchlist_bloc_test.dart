import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc =
        WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });

  final tWatchlistMoviesList = <Movie>[testWatchlistMovie];

  test('initial state should be TopRatedMoviesState.initial()', () {
    expect(watchlistMoviesBloc.state, WatchlistMovieState.initial());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tWatchlistMoviesList));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial().copyWith(state: RequestState.Loading),
      WatchlistMovieState.initial().copyWith(
        state: RequestState.Loaded,
        watchlistMovies: tWatchlistMoviesList,
      )
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      FetchWatchlistMovies().props,
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial().copyWith(state: RequestState.Loading),
      WatchlistMovieState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      FetchWatchlistMovies().props,
    ],
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial().copyWith(state: RequestState.Loading),
      WatchlistMovieState.initial().copyWith(
        state: RequestState.Error,
        message: 'Database Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      FetchWatchlistMovies().props,
    ],
  );
}
