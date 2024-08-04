import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'nowplaying_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
void main() {
  late NowPlayingTVBloc nowPlayingTVBloc;
  late MockGetNowPlayingTV mockGetNowPlayingTV;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    nowPlayingTVBloc = NowPlayingTVBloc(getNowPlayingTV: mockGetNowPlayingTV);
  });

  test('initial state should be empty', () {
    expect(nowPlayingTVBloc.state, NowPlayingTVState.initial());
  });

  final tTvList = <TV>[tTv];

  blocTest<NowPlayingTVBloc, NowPlayingTVState>(
    'Should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tTvList));
      return nowPlayingTVBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTV()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      NowPlayingTVState.initial().copyWith(state: RequestState.Loading),
      NowPlayingTVState.initial().copyWith(
        state: RequestState.Loaded,
        tv: tTvList,
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingTV.execute()),
      FetchNowPlayingTV().props,
    ],
  );

  blocTest<NowPlayingTVBloc, NowPlayingTVState>(
    'Should emit [NowPlayingMovieState.loading(), NowPlayingMovieState.empty()] when data is empty',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => const Right([]));
      return nowPlayingTVBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTV()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      NowPlayingTVState.initial().copyWith(state: RequestState.Loading),
      NowPlayingTVState.initial().copyWith(state: RequestState.Empty),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingTV.execute()),
      FetchNowPlayingTV().props,
    ],
  );

  blocTest<NowPlayingTVBloc, NowPlayingTVState>(
    'Should emit [Loading, Error] when get now playing tv is unsuccessful',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return nowPlayingTVBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTV()),
    expect: () => [
      NowPlayingTVState.initial().copyWith(state: RequestState.Loading),
      NowPlayingTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingTV.execute()),
      FetchNowPlayingTV().props,
    ],
  );
}
