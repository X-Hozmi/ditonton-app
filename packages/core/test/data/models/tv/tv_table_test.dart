import 'package:core/data/models/tv/tv_table.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testTVDetail = TVDetail(
    backdropPath: '/path/to/backdrop.jpg',
    firstAirDate: '2024-01-01',
    genres: [],
    homepage: 'https://',
    id: 1,
    inProduction: false,
    languages: ['en'],
    lastAirDate: '2024-01-01',
    name: 'Test TV Show',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Test TV Show',
    overview: 'This is a test TV show overview.',
    popularity: 10.0,
    posterPath: '/path/to/poster.jpg',
    seasons: [],
    status: 'Ended',
    tagline: 'This is a test tagline.',
    type: 'Scripted',
    voteAverage: 8.5,
    voteCount: 100,
  );

  const testTVTable = TVTable(
    id: 1,
    name: 'Test TV Show',
    overview: 'This is a test TV show overview.',
    posterPath: '/path/to/poster.jpg',
  );

  const testTVJson = {
    'id': 1,
    'name': 'Test TV Show',
    'posterPath': '/path/to/poster.jpg',
    'overview': 'This is a test TV show overview.',
  };

  group('TVTable', () {
    test('should create a TVTable from TVDetail entity', () {
      // act
      final result = TVTable.fromEntity(testTVDetail);

      // assert
      expect(result, testTVTable);
    });

    test('should create a TVTable from Map', () {
      // act
      final result = TVTable.fromMap(testTVJson);

      // assert
      expect(result, testTVTable);
    });

    test('should return a JSON map containing the proper data', () {
      // act
      final result = testTVTable.toJson();

      // assert
      expect(result, testTVJson);
    });

    test('should convert to TV entity', () {
      // act
      final result = testTVTable.toEntity();

      // assert
      expect(result, isA<TV>());
      expect(result.id, testTVTable.id);
      expect(result.overview, testTVTable.overview);
      expect(result.posterPath, testTVTable.posterPath);
      expect(result.name, testTVTable.name);
    });
  });
}
