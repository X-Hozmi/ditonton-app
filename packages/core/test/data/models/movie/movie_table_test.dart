import 'package:core/data/models/movie/movie_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovieTable', () {
    const testMovieDetail = MovieDetail(
      id: 1,
      title: 'Test Movie',
      overview: 'This is a test movie.',
      posterPath: '/path/to/poster.jpg',
      adult: true,
      backdropPath: 'backdropPath',
      genres: [
        Genre(id: 1, name: 'name'),
      ],
      originalTitle: 'originalTitle',
      releaseDate: 'releaseDate',
      runtime: 1,
      voteAverage: 1,
      voteCount: 1,
    );

    const testMovieTable = MovieTable(
      id: 1,
      title: 'Test Movie',
      posterPath: '/path/to/poster.jpg',
      overview: 'This is a test movie.',
    );

    test('should convert MovieTable to JSON correctly', () {
      // act
      final result = testMovieTable.toJson();

      // assert
      expect(result, {
        'id': 1,
        'title': 'Test Movie',
        'posterPath': '/path/to/poster.jpg',
        'overview': 'This is a test movie.',
      });
    });

    test('should create a MovieTable from a MovieDetail entity', () {
      // act
      final result = MovieTable.fromEntity(testMovieDetail);

      // assert
      expect(result, testMovieTable);
    });

    test('should create a MovieTable from a Map', () {
      // arrange
      final Map<String, dynamic> map = {
        'id': 1,
        'title': 'Test Movie',
        'posterPath': '/path/to/poster.jpg',
        'overview': 'This is a test movie.',
      };

      // act
      final result = MovieTable.fromMap(map);

      // assert
      expect(result, testMovieTable);
    });
  });
}
