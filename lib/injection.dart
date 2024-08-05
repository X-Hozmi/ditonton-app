import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie/movie_local_data_source.dart';
import 'package:core/data/datasources/movie/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv/tv_local_data_source.dart';
import 'package:core/data/datasources/tv/tv_remote_data_source.dart';
import 'package:core/data/repositories/movie/movie_repository_impl.dart';
import 'package:core/data/repositories/tv/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie/movie_repository.dart';
import 'package:core/domain/repositories/tv/tv_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movie/domain/usecases/remove_watchlist_movie.dart';
import 'package:movie/domain/usecases/save_watchlist_movie.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/detail/detail_bloc.dart';
import 'package:movie/presentation/bloc/list/list_bloc.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';
import 'package:movie/presentation/bloc/search/search_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/detail/detail_bloc.dart';
import 'package:tv/presentation/bloc/list/list_bloc.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:tv/presentation/bloc/popular/popular_bloc.dart';
import 'package:tv/presentation/bloc/search/search_bloc.dart';
import 'package:tv/presentation/bloc/season/season_bloc.dart';
import 'package:tv/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchBloc(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMovieBloc(
      getPopularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(
      getTopRatedMovies: locator(),
    ),
  );
  locator
      .registerFactory(() => WatchlistMovieBloc(getWatchlistMovies: locator()));
  locator.registerFactory(
    () => NowPlayingMovieBloc(
      getNowPlayingMovies: locator(),
    ),
  );

  // TV Provider
  locator.registerFactory(
    () => TVListBloc(
      getNowPlayingTV: locator(),
      getPopularTV: locator(),
      getTopRatedTV: locator(),
    ),
  );
  locator.registerFactory(
    () => TVDetailBloc(
      getTVDetail: locator(),
      getTVRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSearchBloc(searchTV: locator()),
  );
  locator.registerFactory(
    () => PopularTVBloc(getPopularTV: locator()),
  );
  locator.registerFactory(
    () => TopRatedTVBloc(
      getTopRatedTV: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingTVBloc(
      getNowPlayingTV: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTVBloc(
      getWatchlistTV: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeasonDetailBloc(
      getSeasonDetail: locator(),
    ),
  );

  // Movie UseCases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // TV UseCases
  locator.registerLazySingleton(() => GetNowPlayingTV(locator()));
  locator.registerLazySingleton(() => GetPopularTV(locator()));
  locator.registerLazySingleton(() => GetTopRatedTV(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTV(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTV(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTV(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTV(locator()));
  locator.registerLazySingleton(() => GetWatchlistTV(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));

  // Movie Repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // TV Repository
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Movie Data Sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // TV Data Sources
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVLocalDataSource>(
      () => TVLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
