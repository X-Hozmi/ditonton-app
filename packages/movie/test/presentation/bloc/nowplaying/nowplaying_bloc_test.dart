import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'nowplaying_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMovieBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc =
        NowPlayingMovieBloc(getNowPlayingMovies: mockGetNowPlayingMovies);
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be NowPlayingMovieState.initial()', () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMovieState.initial());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'Should emit [NowPlayingMovieState.loading(), NowPlayingMovieState.loaded(movies)] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      NowPlayingMovieState.initial().copyWith(state: RequestState.Loading),
      NowPlayingMovieState.initial().copyWith(
        state: RequestState.Loaded,
        movies: tMovieList,
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      FetchNowPlayingMovies().props,
    ],
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'Should emit [NowPlayingMovieState.loading(), NowPlayingMovieState.empty()] when data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      NowPlayingMovieState.initial().copyWith(state: RequestState.Loading),
      NowPlayingMovieState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      FetchNowPlayingMovies().props,
    ],
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'Should emit [NowPlayingMovieState.loading(), NowPlayingMovieState.error(message)] when get now playing movies is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      NowPlayingMovieState.initial().copyWith(state: RequestState.Loading),
      NowPlayingMovieState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      FetchNowPlayingMovies().props,
    ],
  );
}
