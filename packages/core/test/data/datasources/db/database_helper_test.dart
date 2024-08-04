import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/movie/movie_table.dart';
import 'package:core/data/models/tv/tv_table.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseHelper dbHelper;

  setUp(() async {
    dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db?.delete(DatabaseHelper().tblWatchlist);
    await db?.delete(DatabaseHelper().tblWatchlistTv);
  });

  tearDown(() async {
    final db = await dbHelper.database;
    await db?.delete(DatabaseHelper().tblWatchlist);
    await db?.delete(DatabaseHelper().tblWatchlistTv);
  });

  test('Database onCreate function creates tables', () async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        dbHelper.onCreate(db, version);
      },
    );

    final movieTable =
        await db.rawQuery('PRAGMA table_info(${dbHelper.tblWatchlist})');
    final tvTable =
        await db.rawQuery('PRAGMA table_info(${dbHelper.tblWatchlistTv})');

    expect(movieTable, isNotEmpty);
    expect(tvTable, isNotEmpty);

    expect(movieTable.length, 4);
    expect(movieTable[0]['name'], 'id');
    expect(movieTable[0]['type'], 'INTEGER');
    expect(movieTable[1]['name'], 'title');
    expect(movieTable[1]['type'], 'TEXT');
    expect(movieTable[2]['name'], 'overview');
    expect(movieTable[2]['type'], 'TEXT');
    expect(movieTable[3]['name'], 'posterPath');
    expect(movieTable[3]['type'], 'TEXT');

    expect(tvTable.length, 4);
    expect(tvTable[0]['name'], 'id');
    expect(tvTable[0]['type'], 'INTEGER');
    expect(tvTable[1]['name'], 'name');
    expect(tvTable[1]['type'], 'TEXT');
    expect(tvTable[2]['name'], 'overview');
    expect(tvTable[2]['type'], 'TEXT');
    expect(tvTable[3]['name'], 'posterPath');
    expect(tvTable[3]['type'], 'TEXT');

    await db.close();
  });

  test('Insert and get movie from watchlist', () async {
    const movie = MovieTable(
      id: 1,
      title: 'Movie Title',
      overview: 'Overview of the movie',
      posterPath: 'poster_path.jpg',
    );

    await dbHelper.insertWatchlistMovie(movie);

    final fetchedMovie = await dbHelper.getMovieById(1);

    expect(fetchedMovie, isNotNull);
    expect(fetchedMovie?['id'], movie.id);
    expect(fetchedMovie?['title'], movie.title);
    expect(fetchedMovie?['overview'], movie.overview);
    expect(fetchedMovie?['posterPath'], movie.posterPath);
  });

  test('Insert and get TV show from watchlist', () async {
    const tvShow = TVTable(
      id: 1,
      name: 'TV Show Name',
      overview: 'Overview of the TV show',
      posterPath: 'poster_path.jpg',
    );

    await dbHelper.insertWatchlistTv(tvShow);

    final fetchedTvShow = await dbHelper.getTVById(1);

    expect(fetchedTvShow, isNotNull);
    expect(fetchedTvShow?['id'], tvShow.id);
    expect(fetchedTvShow?['name'], tvShow.name);
    expect(fetchedTvShow?['overview'], tvShow.overview);
    expect(fetchedTvShow?['posterPath'], tvShow.posterPath);
  });

  test('Remove movie from watchlist', () async {
    const movie = MovieTable(
      id: 1,
      title: 'Movie Title',
      overview: 'Overview of the movie',
      posterPath: 'poster_path.jpg',
    );

    await dbHelper.insertWatchlistMovie(movie);
    await dbHelper.removeWatchlistMovie(movie);

    final fetchedMovie = await dbHelper.getMovieById(1);
    expect(fetchedMovie, isNull);
  });

  test('Remove TV show from watchlist', () async {
    const tvShow = TVTable(
      id: 1,
      name: 'TV Show Name',
      overview: 'Overview of the TV show',
      posterPath: 'poster_path.jpg',
    );

    await dbHelper.insertWatchlistTv(tvShow);
    await dbHelper.removeWatchlistTv(tvShow);

    final fetchedTvShow = await dbHelper.getTVById(1);
    expect(fetchedTvShow, isNull);
  });

  test('Get all movies from watchlist', () async {
    const movie1 = MovieTable(
      id: 1,
      title: 'Movie Title 1',
      overview: 'Overview of the movie 1',
      posterPath: 'poster_path_1.jpg',
    );

    const movie2 = MovieTable(
      id: 2,
      title: 'Movie Title 2',
      overview: 'Overview of the movie 2',
      posterPath: 'poster_path_2.jpg',
    );

    await dbHelper.insertWatchlistMovie(movie1);
    await dbHelper.insertWatchlistMovie(movie2);

    final watchlistMovies = await dbHelper.getWatchlistMovies();

    expect(watchlistMovies, isNotEmpty);
    expect(watchlistMovies.length, 2);
    expect(watchlistMovies[0]['id'], movie1.id);
    expect(watchlistMovies[0]['title'], movie1.title);
    expect(watchlistMovies[1]['id'], movie2.id);
    expect(watchlistMovies[1]['title'], movie2.title);
  });

  test('Get all TV shows from watchlist', () async {
    const tvShow1 = TVTable(
      id: 1,
      name: 'TV Show Name 1',
      overview: 'Overview of the TV show 1',
      posterPath: 'poster_path_1.jpg',
    );

    const tvShow2 = TVTable(
      id: 2,
      name: 'TV Show Name 2',
      overview: 'Overview of the TV show 2',
      posterPath: 'poster_path_2.jpg',
    );

    await dbHelper.insertWatchlistTv(tvShow1);
    await dbHelper.insertWatchlistTv(tvShow2);

    final watchlistTV = await dbHelper.getWatchlistTV();

    expect(watchlistTV, isNotEmpty);
    expect(watchlistTV.length, 2);
    expect(watchlistTV[0]['id'], tvShow1.id);
    expect(watchlistTV[0]['name'], tvShow1.name);
    expect(watchlistTV[1]['id'], tvShow2.id);
    expect(watchlistTV[1]['name'], tvShow2.name);
  });
}
