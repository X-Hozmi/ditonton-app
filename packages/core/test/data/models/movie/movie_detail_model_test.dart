import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/movie/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieDetailResponse', () {
    const testGenreModel = GenreModel(id: 1, name: 'Action');
    const testMovieDetailResponse = MovieDetailResponse(
      adult: false,
      backdropPath: '/path/to/backdrop.jpg',
      budget: 1000000,
      genres: [testGenreModel],
      homepage: 'https://example.com',
      id: 1,
      imdbId: 'tt1234567',
      originalLanguage: 'en',
      originalTitle: 'Test Movie',
      overview: 'This is a test movie.',
      popularity: 10.0,
      posterPath: '/path/to/poster.jpg',
      releaseDate: '2023-01-01',
      revenue: 5000000,
      runtime: 120,
      status: 'Released',
      tagline: 'A test tagline',
      title: 'Test Movie',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    test('should convert MovieDetailResponse to JSON correctly', () {
      // act
      final result = testMovieDetailResponse.toJson();

      // assert
      expect(result, {
        "adult": false,
        "backdrop_path": '/path/to/backdrop.jpg',
        "budget": 1000000,
        "genres": [testGenreModel.toJson()],
        "homepage": 'https://example.com',
        "id": 1,
        "imdb_id": 'tt1234567',
        "original_language": 'en',
        "original_title": 'Test Movie',
        "overview": 'This is a test movie.',
        "popularity": 10.0,
        "poster_path": '/path/to/poster.jpg',
        "release_date": '2023-01-01',
        "revenue": 5000000,
        "runtime": 120,
        "status": 'Released',
        "tagline": 'A test tagline',
        "title": 'Test Movie',
        "video": false,
        "vote_average": 8.5,
        "vote_count": 100,
      });
    });
  });
}
