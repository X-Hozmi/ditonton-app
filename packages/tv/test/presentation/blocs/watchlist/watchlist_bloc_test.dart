import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late WatchlistTVBloc watchlistTVBloc;
  late MockGetWatchlistTV mockGetWatchlistTV;

  setUp(() {
    mockGetWatchlistTV = MockGetWatchlistTV();
    watchlistTVBloc = WatchlistTVBloc(getWatchlistTV: mockGetWatchlistTV);
  });

  final tWatchlistTVList = <TV>[tWatchlistTv];

  test('initial state should be empty', () {
    expect(watchlistTVBloc.state, WatchlistTVState.initial());
  });

  blocTest<WatchlistTVBloc, WatchlistTVState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTV.execute())
          .thenAnswer((_) async => Right(tWatchlistTVList));
      return watchlistTVBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTV()),
    expect: () => [
      WatchlistTVState.initial().copyWith(state: RequestState.Loading),
      WatchlistTVState.initial().copyWith(
        state: RequestState.Loaded,
        watchlistTV: tWatchlistTVList,
      ),
    ],
    verify: (bloc) => [
      verify(mockGetWatchlistTV.execute()),
      FetchWatchlistTV().props,
    ],
  );

  blocTest<WatchlistTVBloc, WatchlistTVState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistTV.execute())
          .thenAnswer((_) async => const Right([]));
      return watchlistTVBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTV()),
    expect: () => [
      WatchlistTVState.initial().copyWith(state: RequestState.Loading),
      WatchlistTVState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (bloc) => [
      verify(mockGetWatchlistTV.execute()),
      FetchWatchlistTV().props,
    ],
  );

  blocTest<WatchlistTVBloc, WatchlistTVState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetWatchlistTV.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')));
      return watchlistTVBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTV()),
    expect: () => [
      WatchlistTVState.initial().copyWith(state: RequestState.Loading),
      WatchlistTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Database Failure',
      ),
    ],
    verify: (bloc) => [
      verify(mockGetWatchlistTV.execute()),
      FetchWatchlistTV().props,
    ],
  );
}
