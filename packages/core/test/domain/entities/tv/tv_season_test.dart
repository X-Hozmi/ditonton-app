import 'package:core/domain/entities/tv/tv_season.dart';
import 'package:test/test.dart';

void main() {
  group('Season', () {
    const season = Season(
      airDate: '2022-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: '/path/to/poster',
      seasonNumber: 1,
    );

    test('create object Season', () {
      expect(season.airDate, '2022-01-01');
      expect(season.episodeCount, 10);
      expect(season.id, 1);
      expect(season.name, 'Season 1');
      expect(season.overview, 'overview');
      expect(season.posterPath, '/path/to/poster');
      expect(season.seasonNumber, 1);
    });

    test('equality', () {
      const season2 = Season(
        airDate: '2022-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: '/path/to/poster',
        seasonNumber: 1,
      );
      expect(season, season2);
    });

    test('inequality', () {
      const season2 = Season(
        airDate: '2022-01-02',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: '/path/to/poster',
        seasonNumber: 1,
      );
      expect(season, isNot(season2));
    });

    test('toString', () {
      expect(season.toString(), isA<String>());
    });
  });
}
