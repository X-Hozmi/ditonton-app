import 'package:core/data/models/tv/tv_episode_model.dart';
import 'package:core/domain/entities/tv/tv_episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEpisodeModel = EpisodeModel(
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
  );

  const testEpisodeJson = {
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
  };

  group('EpisodeModel', () {
    test('should be a subclass of Episode entity', () {
      final episodeEntity = testEpisodeModel.toEntity();
      expect(episodeEntity, isA<Episode>());
    });

    test('should return a valid model from JSON', () {
      // act
      final result = EpisodeModel.fromJson(testEpisodeJson);

      // assert
      expect(result, testEpisodeModel);
    });

    test('should return a JSON map containing the proper data', () {
      // act
      final result = testEpisodeModel.toJson();

      // assert
      expect(result, testEpisodeJson);
    });

    test('should convert to Episode entity', () {
      // act
      final result = testEpisodeModel.toEntity();

      // assert
      expect(result, isA<Episode>());
      expect(result.airDate, testEpisodeModel.airDate);
      expect(result.episodeNumber, testEpisodeModel.episodeNumber);
      expect(result.id, testEpisodeModel.id);
      expect(result.name, testEpisodeModel.name);
      expect(result.overview, testEpisodeModel.overview);
      expect(result.productionCode, testEpisodeModel.productionCode);
      expect(result.seasonNumber, testEpisodeModel.seasonNumber);
      expect(result.stillPath, testEpisodeModel.stillPath);
      expect(result.voteAverage, testEpisodeModel.voteAverage);
      expect(result.voteCount, testEpisodeModel.voteCount);
    });
  });
}
