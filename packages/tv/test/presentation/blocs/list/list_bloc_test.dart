import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/list/list_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV, GetPopularTV, GetTopRatedTV])
void main() {
  late TVListBloc movieListBloc;
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late MockGetPopularTV mockGetPopularTV;
  late MockGetTopRatedTV mockGetTopRatedTV;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    mockGetPopularTV = MockGetPopularTV();
    mockGetTopRatedTV = MockGetTopRatedTV();
    movieListBloc = TVListBloc(
      getNowPlayingTV: mockGetNowPlayingTV,
      getPopularTV: mockGetPopularTV,
      getTopRatedTV: mockGetTopRatedTV,
    );
  });

  test('initial state should be TVListState.initial()', () {
    expect(movieListBloc.state, TVListState.initial());
  });

  final tTVList = <TV>[tTv];

  group('Now Playing TV', () {
    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Right(tTVList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTV()),
      expect: () => [
        TVListState.initial().copyWith(nowPlayingState: RequestState.Loading),
        TVListState.initial().copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTV: tTVList,
        ),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTV()),
      expect: () => [
        TVListState.initial().copyWith(nowPlayingState: RequestState.Loading),
        TVListState.initial().copyWith(nowPlayingState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetNowPlayingTV.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTV()),
      expect: () => [
        TVListState.initial().copyWith(nowPlayingState: RequestState.Loading),
        TVListState.initial().copyWith(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetNowPlayingTV.execute()),
      ],
    );
  });

  group('Popular TV', () {
    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Right(tTVList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTV()),
      expect: () => [
        TVListState.initial().copyWith(popularTVState: RequestState.Loading),
        TVListState.initial().copyWith(
          popularTVState: RequestState.Loaded,
          popularTV: tTVList,
        ),
      ],
      verify: (_) => [
        verify(mockGetPopularTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTV()),
      expect: () => [
        TVListState.initial().copyWith(popularTVState: RequestState.Loading),
        TVListState.initial().copyWith(popularTVState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetPopularTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTV.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTV()),
      expect: () => [
        TVListState.initial().copyWith(popularTVState: RequestState.Loading),
        TVListState.initial().copyWith(
          popularTVState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetPopularTV.execute()),
      ],
    );
  });

  group('Top Rated TV', () {
    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Right(tTVList));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTV()),
      expect: () => [
        TVListState.initial().copyWith(topRatedTVState: RequestState.Loading),
        TVListState.initial().copyWith(
          topRatedTVState: RequestState.Loaded,
          topRatedTV: tTVList,
        ),
      ],
      verify: (_) => [
        verify(mockGetTopRatedTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Empty] when data is empty',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => const Right([]));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTV()),
      expect: () => [
        TVListState.initial().copyWith(topRatedTVState: RequestState.Loading),
        TVListState.initial().copyWith(topRatedTVState: RequestState.Empty),
      ],
      verify: (_) => [
        verify(mockGetTopRatedTV.execute()),
      ],
    );

    blocTest<TVListBloc, TVListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTV.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTV()),
      expect: () => [
        TVListState.initial().copyWith(topRatedTVState: RequestState.Loading),
        TVListState.initial().copyWith(
          topRatedTVState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => [
        verify(mockGetTopRatedTV.execute()),
      ],
    );
  });
}
