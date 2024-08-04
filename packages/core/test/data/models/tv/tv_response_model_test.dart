import 'dart:convert';
import 'package:core/data/models/tv/tv_model.dart';
import 'package:core/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../test/json_reader.dart';

void main() {
  const tTVModel = TVModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalname',
    overview: 'overview',
    popularity: 1,
    posterPath: 'poster_path',
    firstAirDate: 'first_air_date',
    name: 'name',
    originalLanguage: 'original_language',
    voteAverage: 1,
    voteCount: 1,
  );
  const tTVResponseModel = TVResponse(tvList: <TVModel>[tTVModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/now_playing_tv.json'));
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTVResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdropPath": "backdropPath",
            "genreIds": [1, 2, 3],
            "id": 1,
            "original_name": "originalname",
            "overview": "overview",
            "popularity": 1,
            "poster_path": "poster_path",
            "first_air_date": "first_air_date",
            "name": "name",
            "original_language": "original_language",
            "vote_average": 1,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
