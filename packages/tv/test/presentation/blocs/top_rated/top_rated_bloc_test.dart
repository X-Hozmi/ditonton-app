import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/top_rated/top_rated_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTV])
void main() {
  late TopRatedTVBloc topRatedTVBloc;
  late MockGetTopRatedTV mockGetTopRatedTV;

  setUp(() {
    mockGetTopRatedTV = MockGetTopRatedTV();
    topRatedTVBloc = TopRatedTVBloc(getTopRatedTV: mockGetTopRatedTV);
  });

  final tTVList = <TV>[tTv];

  test('initial state should be empty', () {
    expect(topRatedTVBloc.state, TopRatedTVState.initial());
  });

  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTV.execute()).thenAnswer((_) async => Right(tTVList));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTV()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TopRatedTVState.initial().copyWith(state: RequestState.Loading),
      TopRatedTVState.initial().copyWith(
        state: RequestState.Loaded,
        tv: tTVList,
      ),
    ],
    verify: (bloc) => [
      verify(mockGetTopRatedTV.execute()),
      FetchTopRatedTV().props,
    ],
  );

  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
    build: () {
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTV()),
    expect: () => [
      TopRatedTVState.initial().copyWith(state: RequestState.Loading),
      TopRatedTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (bloc) => [
      verify(mockGetTopRatedTV.execute()),
      FetchTopRatedTV().props,
    ],
  );
}
