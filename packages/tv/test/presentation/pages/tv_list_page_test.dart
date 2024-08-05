import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/bloc/popular/popular_bloc.dart';
import 'package:tv/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:tv/presentation/pages/tv_list_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTVBloc
    extends MockBloc<NowPlayingTVEvent, NowPlayingTVState>
    implements NowPlayingTVBloc {}

class MockPopularTVBloc extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

class MockTopRatedTVBloc extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

class FakeNowPlayingTVEvent extends Fake implements NowPlayingTVEvent {}

class FakeNowPlayingTVState extends Fake implements NowPlayingTVState {}

class FakePopularTVEvent extends Fake implements PopularTVEvent {}

class FakePopularTVState extends Fake implements PopularTVState {}

class FakeTopRatedTVEvent extends Fake implements TopRatedTVEvent {}

class FakeTopRatedTVState extends Fake implements TopRatedTVState {}

void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;
  late MockPopularTVBloc mockPopularTVBloc;
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingTVEvent());
    registerFallbackValue(FakeNowPlayingTVState());
    registerFallbackValue(FakePopularTVEvent());
    registerFallbackValue(FakePopularTVState());
    registerFallbackValue(FakeTopRatedTVEvent());
    registerFallbackValue(FakeTopRatedTVState());
  });

  setUp(() {
    mockNowPlayingTVBloc = MockNowPlayingTVBloc();
    mockPopularTVBloc = MockPopularTVBloc();
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTVBloc>(
          create: (_) => mockNowPlayingTVBloc,
        ),
        BlocProvider<PopularTVBloc>(
          create: (_) => mockPopularTVBloc,
        ),
        BlocProvider<TopRatedTVBloc>(
          create: (_) => mockTopRatedTVBloc,
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
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      NowPlayingTVState(
          state: RequestState.Loading, tv: tTvList, message: 'message'),
    );
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState(
          state: RequestState.Loading, tv: tTvList, message: 'message'),
    );
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState(
          state: RequestState.Loading, tv: tTvList, message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const TVListPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('should display movie lists when states are loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      NowPlayingTVState(
          state: RequestState.Loaded, tv: tTvList, message: 'message'),
    );
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState(
          state: RequestState.Loaded, tv: tTvList, message: 'message'),
    );
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState(
          state: RequestState.Loaded, tv: tTvList, message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const TVListPage()));

    expect(find.byType(TVList), findsNWidgets(3));
  });

  testWidgets('should display error message when states are error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      NowPlayingTVState(
          state: RequestState.Error, message: 'Error message', tv: tTvList),
    );
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState(
          state: RequestState.Error, message: 'Error message', tv: tTvList),
    );
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState(
          state: RequestState.Error, message: 'Error message', tv: tTvList),
    );

    await tester.pumpWidget(makeTestableWidget(const TVListPage()));

    expect(find.text('Gagal'), findsNWidgets(3));
  });

  testWidgets('should navigate to search page when search bar is tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      const NowPlayingTVState(
          state: RequestState.Loaded, tv: [], message: 'message'),
    );
    when(() => mockPopularTVBloc.state).thenReturn(
      const PopularTVState(
          state: RequestState.Loaded, tv: [], message: 'message'),
    );
    when(() => mockTopRatedTVBloc.state).thenReturn(
      const TopRatedTVState(
          state: RequestState.Loaded, tv: [], message: 'message'),
    );

    await tester.pumpWidget(makeTestableWidget(const TVListPage()));

    final searchBar = find.byKey(const Key('searchBar'));
    await tester.tap(searchBar);
    await tester.pumpAndSettle();

    expect(find.byType(Container), findsOneWidget);
  });
}
