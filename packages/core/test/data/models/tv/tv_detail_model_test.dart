import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv/tv_detail_model.dart';
import 'package:core/data/models/tv/tv_season_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TVDetailResponse', () {
    const testGenres = [
      GenreModel(id: 1, name: 'Drama'),
      GenreModel(id: 2, name: 'Action'),
    ];

    const testSeasons = [
      SeasonModel(
        id: 1,
        airDate: '2023-01-01',
        episodeCount: 10,
        name: 'Season 1',
        overview: 'Overview of Season 1',
        posterPath: '/path/to/season1.jpg',
        seasonNumber: 1,
      ),
    ];

    const testTVDetailResponse = TVDetailResponse(
      backdropPath: '/path/to/backdrop.jpg',
      firstAirDate: '2023-01-01',
      genres: testGenres,
      homepage: 'https://example.com',
      id: 1,
      inProduction: true,
      languages: ['en'],
      lastAirDate: '2023-12-31',
      name: 'Test TV Show',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'Test TV Show',
      overview: 'This is a test TV show.',
      popularity: 7.5,
      posterPath: '/path/to/poster.jpg',
      seasons: testSeasons,
      status: 'Ended',
      tagline: 'This is a tagline.',
      type: 'scripted',
      voteAverage: 8.0,
      voteCount: 100,
    );

    test('should convert TVDetailResponse to JSON correctly', () {
      // act
      final result = testTVDetailResponse.toJson();

      // assert
      expect(result, {
        "backdrop_path": '/path/to/backdrop.jpg',
        "first_air_date": '2023-01-01',
        "genres": List<dynamic>.from(testGenres.map((x) => x.toJson())),
        "homepage": 'https://example.com',
        "id": 1,
        "in_production": true,
        "languages": ['en'],
        "last_air_date": '2023-12-31',
        "name": 'Test TV Show',
        "number_of_episodes": 10,
        "number_of_seasons": 1,
        "origin_country": ['US'],
        "original_language": 'en',
        "original_name": 'Test TV Show',
        "overview": 'This is a test TV show.',
        "popularity": 7.5,
        "poster_path": '/path/to/poster.jpg',
        "seasons": List<dynamic>.from(testSeasons.map((x) => x.toJson())),
        "status": 'Ended',
        "tagline": 'This is a tagline.',
        "type": 'scripted',
        "vote_average": 8.0,
        "vote_count": 100,
      });
    });
  });
}
