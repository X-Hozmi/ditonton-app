import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/detail/detail_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListStatusTV,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailBloc detailTVBloc;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListStatusTV mockGetWatchListStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchListStatusTV = MockGetWatchListStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    detailTVBloc = TVDetailBloc(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      getWatchListStatus: mockGetWatchListStatusTV,
      saveWatchlist: mockSaveWatchlistTV,
      removeWatchlist: mockRemoveWatchlistTV,
    );
  });

  const tId = 1;

  group('Get Detail TV', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [DetailTVLoading, DetailTVLoaded, RecomendationLoading, RecommendationLoaded] when get detail tv and recommendation tvs success',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => const Right(tTvDetail));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TVDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.Loading,
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
        ),
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
          tvRecommendationsState: RequestState.Loaded,
          tvRecommendations: tTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        const FetchTVDetail(tId).props;
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [DetailTVError] when get detail tv failed',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        const FetchTVDetail(tId).props;
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [DetailTVLoading, DetailTVLoaded, RecommendationEmpty] when get recommendation tvs empty',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => const Right(tTvDetail));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TVDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.Loading,
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
        ),
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
          tvRecommendationsState: RequestState.Empty,
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        const FetchTVDetail(tId).props;
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [DetailTVLoading, RecomendationLoading, DetailTVLoaded, RecommendationError] when get recommendation tvs failed',
      build: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => const Right(tTvDetail));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loading,
        ),
        TVDetailState.initial().copyWith(
          tvRecommendationsState: RequestState.Loading,
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
        ),
        TVDetailState.initial().copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvDetail,
          tvRecommendationsState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        const FetchTVDetail(tId).props;
      },
    );
  });

  group('Load Watchlist Status TV', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatusTV.execute(tId))
            .thenAnswer((_) async => true);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTV(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusTV.execute(tId)),
        const LoadWatchlistStatusTV(tId).props,
      ],
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatusTV.execute(tId))
            .thenAnswer((_) async => false);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTV(tId)),
      expect: () => [
        TVDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusTV.execute(tId)),
        const LoadWatchlistStatusTV(tId).props,
      ],
    );
  });

  group('Added To Watchlist TV', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistTV.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusTV.execute(tTvDetail.id))
            .thenAnswer((_) async => true);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistTV(tTvDetail)),
      expect: () => [
        TVDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        TVDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTV.execute(tTvDetail));
        verify(mockGetWatchListStatusTV.execute(tTvDetail.id));
        const AddWatchlistTV(tTvDetail).props;
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistTV.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTV.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistTV(tTvDetail)),
      expect: () => [
        TVDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTV.execute(tTvDetail));
        verify(mockGetWatchListStatusTV.execute(tTvDetail.id));
        const AddWatchlistTV(tTvDetail).props;
      },
    );
  });

  group('Remove From Watchlist TV', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTV.execute(tTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusTV.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlistTV(tTvDetail)),
      expect: () => [
        TVDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTV.execute(tTvDetail));
        verify(mockGetWatchListStatusTV.execute(tTvDetail.id));
        const RemoveFromWatchlistTV(tTvDetail).props;
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Shoud emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTV.execute(tTvDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTV.execute(tTvDetail.id))
            .thenAnswer((_) async => false);
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlistTV(tTvDetail)),
      expect: () => [
        TVDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTV.execute(tTvDetail));
        verify(mockGetWatchListStatusTV.execute(tTvDetail.id));
        const RemoveFromWatchlistTV(tTvDetail).props;
      },
    );
  });
}
