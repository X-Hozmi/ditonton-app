import 'package:core/data/models/tv/tv_episode_model.dart';
import 'package:core/data/models/tv/tv_season_detail_model.dart';
import 'package:core/domain/entities/tv/tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testSeasonDetailResponse = SeasonDetailResponse(
    id: 1,
    airDate: '2023-01-01',
    episodes: [
      EpisodeModel(
        airDate: '2023-01-01',
        episodeNumber: 1,
        id: 1,
        name: 'Test Episode',
        overview: 'This is a test episode.',
        productionCode: 'TEST001',
        seasonNumber: 1,
        stillPath: '/path/to/still.jpg',
        voteAverage: 8.5,
        voteCount: 100,
      ),
    ],
    name: 'Test Season',
    overview: 'This is a test season overview.',
    posterPath: '/path/to/poster.jpg',
    seasonNumber: 1,
  );

  const testSeasonDetailJson = {
    'id': 1,
    'air_date': '2023-01-01',
    'episodes': [
      {
        'air_date': '2023-01-01',
        'episode_number': 1,
        'id': 1,
        'name': 'Test Episode',
        'overview': 'This is a test episode.',
        'production_code': 'TEST001',
        'season_number': 1,
        'still_path': '/path/to/still.jpg',
        'vote_average': 8.5,
        'vote_count': 100,
      }
    ],
    'name': 'Test Season',
    'overview': 'This is a test season overview.',
    'poster_path': '/path/to/poster.jpg',
    'season_number': 1,
  };

  group('SeasonDetailResponse', () {
    test('should be a subclass of SeasonDetail entity', () {
      final seasonEntity = testSeasonDetailResponse.toEntity();
      expect(seasonEntity, isA<SeasonDetail>());
    });

    test('should return a valid model from JSON', () {
      // act
      final result = SeasonDetailResponse.fromJson(testSeasonDetailJson);

      // assert
      expect(result, testSeasonDetailResponse);
    });

    test('should return a JSON map containing the proper data', () {
      // act
      final result = testSeasonDetailResponse.toJson();

      // assert
      expect(result, testSeasonDetailJson);
    });

    test('should convert to SeasonDetail entity', () {
      // act
      final result = testSeasonDetailResponse.toEntity();

      // assert
      expect(result, isA<SeasonDetail>());
      expect(result.id, testSeasonDetailResponse.id);
      expect(result.airDate, testSeasonDetailResponse.airDate);
      expect(
          result.episodes,
          testSeasonDetailResponse.episodes
              .map((episode) => episode.toEntity())
              .toList());
      expect(result.name, testSeasonDetailResponse.name);
      expect(result.overview, testSeasonDetailResponse.overview);
      expect(result.posterPath, testSeasonDetailResponse.posterPath);
      expect(result.seasonNumber, testSeasonDetailResponse.seasonNumber);
    });
  });
}
