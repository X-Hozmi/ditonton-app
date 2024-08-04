import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc =
        PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

  final tMoviesList = <Movie>[testMovie];

  test('initial state should be PopularMovieState.initial()', () {
    expect(popularMoviesBloc.state, PopularMovieState.initial());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, Loaded(movies)] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      PopularMovieState.initial().copyWith(state: RequestState.Loading),
      PopularMovieState.initial().copyWith(
        state: RequestState.Loaded,
        movies: tMoviesList,
      ),
    ],
    verify: (_) => [
      verify(mockGetPopularMovies.execute()),
      FetchPopularMovies().props,
    ],
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      PopularMovieState.initial().copyWith(state: RequestState.Loading),
      PopularMovieState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockGetPopularMovies.execute()),
      FetchPopularMovies().props,
    ],
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      PopularMovieState.initial().copyWith(state: RequestState.Loading),
      PopularMovieState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetPopularMovies.execute()),
      FetchPopularMovies().props,
    ],
  );
}
