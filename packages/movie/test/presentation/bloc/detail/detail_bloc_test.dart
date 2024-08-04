import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movie/domain/usecases/remove_watchlist_movie.dart';
import 'package:movie/domain/usecases/save_watchlist_movie.dart';
import 'package:movie/presentation/bloc/detail/detail_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovie,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieDetailBloc detailMovieBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    detailMovieBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatusMovie,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
    );
  });

  const tId = 1;

  group('Get Detail Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [DetailMovieLoading, DetailMovieLoaded, RecomendationLoading, RecommendationLoaded] when get detail movie and recommendation movies success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.Loading,
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.Loaded,
          movieRecommendations: testMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [DetailMovieError] when get detail movie failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [DetailMovieLoading, DetailMovieLoaded, RecommendationEmpty] when get recommendation movies empty',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.Loading,
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.Empty,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [DetailMovieLoading, RecomendationLoading, DetailMovieLoaded, RecommendationError] when get recommendation movies failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loading,
        ),
        MovieDetailState.initial().copyWith(
          movieRecommendationsState: RequestState.Loading,
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
        ),
        MovieDetailState.initial().copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        const FetchMovieDetail(tId).props;
      },
    );
  });

  group('Load Watchlist Status Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusMovie.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusMovie.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );
  });

  group('Added To Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        const AddWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        const AddWatchlistMovie(testMovieDetail).props;
      },
    );
  });

  group('Remove From Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        const RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        const RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );
  });
}
