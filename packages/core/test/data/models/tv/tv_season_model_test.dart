import 'package:core/data/models/tv/tv_season_model.dart';
import 'package:core/domain/entities/tv/tv_season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testSeasonModel = SeasonModel(
    airDate: '2023-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Test Season',
    overview: 'This is a test season overview.',
    posterPath: '/path/to/poster.jpg',
    seasonNumber: 1,
  );

  const testSeasonJson = {
    'air_date': '2023-01-01',
    'episode_count': 10,
    'id': 1,
    'name': 'Test Season',
    'overview': 'This is a test season overview.',
    'poster_path': '/path/to/poster.jpg',
    'season_number': 1,
  };

  group('SeasonModel', () {
    test('should be a subclass of Season entity', () {
      final seasonEntity = testSeasonModel.toEntity();
      expect(seasonEntity, isA<Season>());
    });

    test('should return a valid model from JSON', () {
      // act
      final result = SeasonModel.fromJson(testSeasonJson);

      // assert
      expect(result, testSeasonModel);
    });

    test('should return a JSON map containing the proper data', () {
      // act
      final result = testSeasonModel.toJson();

      // assert
      expect(result, testSeasonJson);
    });

    test('should convert to Season entity', () {
      // act
      final result = testSeasonModel.toEntity();

      // assert
      expect(result, isA<Season>());
      expect(result.airDate, testSeasonModel.airDate);
      expect(result.episodeCount, testSeasonModel.episodeCount);
      expect(result.id, testSeasonModel.id);
      expect(result.name, testSeasonModel.name);
      expect(result.overview, testSeasonModel.overview);
      expect(result.posterPath, testSeasonModel.posterPath);
      expect(result.seasonNumber, testSeasonModel.seasonNumber);
    });
  });
}
