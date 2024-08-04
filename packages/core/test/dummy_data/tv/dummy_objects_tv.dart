import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv/tv_season_model.dart';
import 'package:core/data/models/tv/tv_table.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/domain/entities/tv/tv_detail.dart';

final testTV = TV(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2002-05-01',
  name: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
  originalLanguage: 'EN',
);

final testTVList = [testTV];

const testTVDetail = TVDetail(
  backdropPath: "backdropPath",
  genres: [
    GenreModel(id: 1, name: "Action"),
  ],
  id: 1,
  overview: "overview",
  posterPath: "posterPath",
  firstAirDate: "releaseDate",
  name: "name",
  voteAverage: 1,
  voteCount: 1,
  lastAirDate: '2021-05-17',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  seasons: [
    SeasonModel(
        airDate: '2024-05-17',
        episodeCount: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1),
  ],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  homepage: 'homepage',
  inProduction: true,
  languages: ['en-US'],
  originCountry: ['English'],
  originalLanguage: 'en-US',
  originalName: 'originalName',
  popularity: 1,
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTVTable = TVTable(
  id: 1,
  name: "name",
  posterPath: "posterPath",
  overview: "overview",
);

final testTVMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
