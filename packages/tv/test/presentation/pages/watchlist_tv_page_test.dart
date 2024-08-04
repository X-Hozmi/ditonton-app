import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:tv/presentation/pages/watchlist_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistTVBloc extends MockBloc<WatchlistTVEvent, WatchlistTVState>
    implements WatchlistTVBloc {}

class FakeWatchlistTVEvent extends Fake implements WatchlistTVEvent {}

class FakeWatchlistTVState extends Fake implements WatchlistTVState {}

void main() {
  late MockWatchlistTVBloc mockWatchlistTVBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTVEvent());
    registerFallbackValue(FakeWatchlistTVState());
  });

  setUp(() {
    mockWatchlistTVBloc = MockWatchlistTVBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<WatchlistTVBloc>.value(
        value: mockWatchlistTVBloc,
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state).thenReturn(
      WatchlistTVState.initial().copyWith(state: RequestState.Loading),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state)
        .thenReturn(WatchlistTVState.initial().copyWith(
      state: RequestState.Loaded,
      watchlistTV: tTvList,
    ));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state).thenReturn(
      WatchlistTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Error Message',
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text when data is empty',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state).thenReturn(
      WatchlistTVState.initial().copyWith(state: RequestState.Empty),
    );

    final textErrorBarFinder = find.text('Empty Watchlist');

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(textErrorBarFinder, findsOneWidget);
  });
}
