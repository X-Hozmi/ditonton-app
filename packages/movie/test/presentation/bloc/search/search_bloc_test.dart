import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/search/search_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc searchMoviesBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMoviesBloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  test('initial state should be MovieSearchState.initial()', () {
    expect(searchMoviesBloc.state, MovieSearchState.initial());
  });

  final tMovieList = <Movie>[testMovie];
  const tQuery = 'spiderman';

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchState.initial().copyWith(state: RequestState.Loading),
      MovieSearchState.initial().copyWith(
        state: RequestState.Loaded,
        searchResult: tMovieList,
      ),
    ],
    verify: (_) => [
      verify(mockSearchMovies.execute(tQuery)),
      const FetchMovieSearch(tQuery).props,
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchState.initial().copyWith(state: RequestState.Loading),
      MovieSearchState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockSearchMovies.execute(tQuery)),
      const FetchMovieSearch(tQuery).props,
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchState.initial().copyWith(state: RequestState.Loading),
      MovieSearchState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockSearchMovies.execute(tQuery)),
      const FetchMovieSearch(tQuery).props,
    ],
  );
}
