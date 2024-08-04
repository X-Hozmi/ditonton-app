import 'package:core/data/models/tv/tv_model.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';

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

  final tTV = TV(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
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

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });
}
