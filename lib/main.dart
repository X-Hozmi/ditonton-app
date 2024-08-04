import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/search_page.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/detail/detail_bloc.dart';
import 'package:movie/presentation/bloc/list/list_bloc.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';
import 'package:movie/presentation/bloc/search/search_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/nowplaying_movies_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/detail/detail_bloc.dart';
import 'package:tv/presentation/bloc/list/list_bloc.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:tv/presentation/bloc/popular/popular_bloc.dart';
import 'package:tv/presentation/bloc/search/search_bloc.dart';
import 'package:tv/presentation/bloc/season/season_bloc.dart';
import 'package:tv/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:tv/presentation/pages/nowplaying_tv_page.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/tv_season_detail_page.dart';
import 'package:tv/presentation/pages/watchlist_tv_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.initialize();
  di.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Movie Providers
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMovieBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMovieBloc>()),
        // TV Providers
        BlocProvider(create: (_) => di.locator<TVListBloc>()),
        BlocProvider(create: (_) => di.locator<TVDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingTVBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeasonDetailBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case NOW_PLAYING_MOVIE_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const NowplayingMoviePage());
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case WATCHLIST_MOVIE_ROUTE:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            case NOW_PLAYING_TV_ROUTE:
              return CupertinoPageRoute(
                  builder: (_) => const NowplayingTVPage());
            case TOP_RATED_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => const TopRatedTVPage());
            case POPULAR_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => const PopularTVPage());
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case WATCHLIST_TV_ROUTE:
              return MaterialPageRoute(builder: (_) => const WatchlistTVPage());
            case SEASON_DETAIL_ROUTE:
              final args = settings.arguments as Map;
              return MaterialPageRoute(
                builder: (_) => TVSeasonDetailPage(
                  id: args['id'],
                  seasonNumber: args['seasonNumber'],
                ),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
