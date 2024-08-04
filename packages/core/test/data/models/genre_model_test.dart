import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/genre_model.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Action');

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // arrange
      final expectedMap = {
        "id": 1,
        "name": "Action",
      };
      // act
      final result = tGenreModel.toJson();
      // assert
      expect(result, expectedMap);
    });
  });
}
