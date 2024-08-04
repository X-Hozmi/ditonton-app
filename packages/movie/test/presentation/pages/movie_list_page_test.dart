import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:movie/presentation/pages/movie_list_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class FakeNowPlayingMovieEvent extends Fake implements NowPlayingMovieEvent {}

class FakeNowPlayingMovieState extends Fake implements NowPlayingMovieState {}

class FakePopularMovieEvent extends Fake implements PopularMovieEvent {}

class FakePopularMovieState extends Fake implements PopularMovieState {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

void main() {
  late MockNowPlayingMovieBloc mockNowPlayingMovieBloc;
  late MockPopularMovieBloc mockPopularMovieBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMovieEvent());
    registerFallbackValue(FakeNowPlayingMovieState());
    registerFallbackValue(FakePopularMovieEvent());
    registerFallbackValue(FakePopularMovieState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  setUp(() {
    mockNowPlayingMovieBloc = MockNowPlayingMovieBloc();
    mockPopularMovieBloc = MockPopularMovieBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>(
          create: (_) => mockNowPlayingMovieBloc,
        ),
        BlocProvider<PopularMovieBloc>(
          create: (_) => mockPopularMovieBloc,
        ),
        BlocProvider<TopRatedMoviesBloc>(
          create: (_) => mockTopRatedMoviesBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SEARCH_ROUTE:
              return MaterialPageRoute(builder: (_) => Container());
            case NOW_PLAYING_MOVIE_ROUTE:
              return MaterialPageRoute(builder: (_) => Container());
            case POPULAR_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => Container());
            case TOP_RATED_MOVIES_ROUTE:
              return MaterialPageRoute(builder: (_) => Container());
            case MOVIE_DETAIL_ROUTE:
              return MaterialPageRoute(builder: (_) => Container());
            default:
              return MaterialPageRoute(builder: (_) => Container());
          }
        },
      ),
    );
  }

  testWidgets('should display loading indicators when states are loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      NowPlayingMovieState(
          state: RequestState.Loading,
          movies: testMovieList,
          message: 'message'),
    );
    when(() => mockPopularMovieBloc.state).thenReturn(
      PopularMovieState(
          state: RequestState.Loading,
          movies: testMovieList,
          message: 'message'),
    );
    when(() => mockTopRatedMoviesBloc.state).thenReturn(
      TopRatedMoviesState(
          state: RequestState.Loading,
          movies: testMovieList,
          message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieListPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display movie lists when states are loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      NowPlayingMovieState(
          state: RequestState.Loaded,
          movies: testMovieList,
          message: 'message'),
    );
    when(() => mockPopularMovieBloc.state).thenReturn(
      PopularMovieState(
          state: RequestState.Loaded,
          movies: testMovieList,
          message: 'message'),
    );
    when(() => mockTopRatedMoviesBloc.state).thenReturn(
      TopRatedMoviesState(
          state: RequestState.Loaded,
          movies: testMovieList,
          message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieListPage()));

    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('should display error message when states are error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      NowPlayingMovieState(
          state: RequestState.Error,
          message: 'Error message',
          movies: testMovieList),
    );
    when(() => mockPopularMovieBloc.state).thenReturn(
      PopularMovieState(
          state: RequestState.Error,
          message: 'Error message',
          movies: testMovieList),
    );
    when(() => mockTopRatedMoviesBloc.state).thenReturn(
      TopRatedMoviesState(
          state: RequestState.Error,
          message: 'Error message',
          movies: testMovieList),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieListPage()));

    expect(find.text('Gagal'), findsNWidgets(3));
  });

  testWidgets('should navigate to search page when search bar is tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(
          state: RequestState.Loaded, movies: [], message: 'message'),
    );
    when(() => mockPopularMovieBloc.state).thenReturn(
      const PopularMovieState(
          state: RequestState.Loaded, movies: [], message: 'message'),
    );
    when(() => mockTopRatedMoviesBloc.state).thenReturn(
      const TopRatedMoviesState(
          state: RequestState.Loaded, movies: [], message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieListPage()));

    final searchBar = find.byKey(const Key('searchBar'));
    await tester.tap(searchBar);
    await tester.pumpAndSettle();

    expect(find.byType(Container), findsOneWidget);
  });
}
