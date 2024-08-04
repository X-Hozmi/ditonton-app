import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv/tv_detail_model.dart';
import 'package:core/data/models/tv/tv_episode_model.dart';
import 'package:core/data/models/tv/tv_model.dart';
import 'package:core/data/models/tv/tv_season_detail_model.dart';
import 'package:core/data/models/tv/tv_season_model.dart';
import 'package:core/data/repositories/tv/tv_repository_impl.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/dummy_objects_tv.dart';
import '../../../helpers/tv/test_helper_tv.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTVModel = TVModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    originalLanguage: 'EN',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTV = TV(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    originalLanguage: 'EN',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('Now Playing TV', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV()).thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(result,
          equals(const Left(ConnectionFailure('Gagal terhubung ke internet'))));
    });
  });

  group('Popular TV', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTV();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTV();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getPopularTV();
      // assert
      expect(
          result, const Left(ConnectionFailure('Gagal terhubung ke internet')));
    });
  });

  group('Top Rated TV', () {
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTopRatedTV();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTV();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getTopRatedTV();
      // assert
      expect(
          result, const Left(ConnectionFailure('Gagal terhubung ke internet')));
    });
  });

  group('Get TV Detail', () {
    const tId = 121;
    const tTVResponse = TVDetailResponse(
      backdropPath: "backdropPath",
      genres: [
        GenreModel(id: 1, name: "Action"),
      ],
      id: 1,
      overview: "overview",
      posterPath: "posterPath",
      firstAirDate: "releaseDate",
      name: "name",
      voteAverage: 1,
      voteCount: 1,
      lastAirDate: '2021-05-17',
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      seasons: [
        SeasonModel(
            airDate: '2024-05-17',
            episodeCount: 1,
            id: 1,
            name: 'name',
            overview: 'overview',
            posterPath: 'posterPath',
            seasonNumber: 1),
      ],
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      homepage: 'homepage',
      inProduction: true,
      languages: ['en-US'],
      originCountry: ['English'],
      originalLanguage: 'en-US',
      originalName: 'originalName',
      popularity: 1,
    );

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(const Right(testTVDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result,
          equals(const Left(ConnectionFailure('Gagal terhubung ke internet'))));
    });
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    const tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTVList);
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(result,
          equals(const Left(ConnectionFailure('Gagal terhubung ke internet'))));
    });
  });

  group('Seach TV', () {
    const tQuery = 'spiderman';

    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      expect(
          result, const Left(ConnectionFailure('Gagal terhubung ke internet')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TV', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTV())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTV();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTVTable))
          .thenAnswer((_) async => 'Ditambahkan ke daftar tonton');
      // act
      final result = await repository.saveWatchlist(testTVDetail);
      // assert
      expect(result, const Right('Ditambahkan ke daftar tonton'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTVDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Dihapus dari daftar tonton');
      // act
      final result = await repository.removeWatchlist(testTVDetail);
      // assert
      expect(result, const Right('Dihapus dari daftar tonton'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTVDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('Get TV Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    const tSeasonDetailResponse = SeasonDetailResponse(
      airDate: '2024-05-17',
      id: 1,
      name: 'Season 1',
      overview: 'Overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
      episodes: [
        EpisodeModel(
            airDate: 'airDate',
            episodeNumber: 1,
            id: 1,
            name: 'name',
            overview: 'overview',
            productionCode: 'productionCode',
            seasonNumber: 1,
            stillPath: 'stillPath',
            voteAverage: 1,
            voteCount: 1)
      ],
    );

    test(
        'should return SeasonDetail when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
          .thenAnswer((_) async => tSeasonDetailResponse);
      // act
      final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
      expect(result, Right(tSeasonDetailResponse.toEntity()));
    });

    test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
          .thenThrow(const SocketException('Gagal terhubung ke internet'));
      // act
      final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
      expect(
          result, const Left(ConnectionFailure('Gagal terhubung ke internet')));
    });
  });

  group('get watchlist tvs', () {
    test('should return empty list when no data found', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTV()).thenAnswer((_) async => []);
      // act
      final result = await repository.getWatchlistTV();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, []);
    });
  });
}
