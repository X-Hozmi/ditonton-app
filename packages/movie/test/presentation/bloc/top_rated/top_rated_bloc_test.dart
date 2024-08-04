import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc =
        TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
  });

  final tMoviesList = <Movie>[testMovie];

  test('initial state should be TopRatedMoviesState.initial()', () {
    expect(topRatedMoviesBloc.state, TopRatedMoviesState.initial());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TopRatedMoviesState.initial().copyWith(state: RequestState.Loading),
      TopRatedMoviesState.initial().copyWith(
        state: RequestState.Loaded,
        movies: tMoviesList,
      )
    ],
    verify: (_) => [
      verify(mockGetTopRatedMovies.execute()),
      FetchTopRatedMovies().props,
    ],
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'Should emit [Loading, Error] when get top rated movies is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesState.initial().copyWith(state: RequestState.Loading),
      TopRatedMoviesState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetTopRatedMovies.execute()),
      FetchTopRatedMovies().props,
    ],
  );
}
