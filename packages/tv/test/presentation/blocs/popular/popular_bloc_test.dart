import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular/popular_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late PopularTVBloc popularTVBloc;
  late MockGetPopularTV mockGetPopularTV;

  setUp(() {
    mockGetPopularTV = MockGetPopularTV();
    popularTVBloc = PopularTVBloc(getPopularTV: mockGetPopularTV);
  });

  final tTVList = <TV>[tTv];

  test('initial state should be empty', () {
    expect(popularTVBloc.state, PopularTVState.initial());
  });

  blocTest<PopularTVBloc, PopularTVState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTV.execute()).thenAnswer((_) async => Right(tTVList));
      return popularTVBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTV()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      PopularTVState.initial().copyWith(state: RequestState.Loading),
      PopularTVState.initial().copyWith(
        state: RequestState.Loaded,
        tv: tTVList,
      ),
    ],
    verify: (_) => [
      verify(mockGetPopularTV.execute()),
      FetchPopularTV().props,
    ],
  );

  blocTest<PopularTVBloc, PopularTVState>(
    'Should emit [Loading, Error] when get popular tv is unsuccessful',
    build: () {
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularTVBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTV()),
    expect: () => [
      PopularTVState.initial().copyWith(state: RequestState.Loading),
      PopularTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetPopularTV.execute()),
      FetchPopularTV().props,
    ],
  );
}
