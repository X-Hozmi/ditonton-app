import 'package:flutter/material.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/detail/detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class FakeTVDetailEvent extends Fake implements TVDetailEvent {}

class FakeTVDetailState extends Fake implements TVDetailState {}

void main() {
  late MockTVDetailBloc mockTVDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeTVDetailEvent());
    registerFallbackValue(FakeTVDetailState());
  });

  setUp(() {
    mockTVDetailBloc = MockTVDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVDetailBloc>.value(
      value: mockTVDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: tTvDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: tTvDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: [tTv],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Show display snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockTVDetailBloc,
      Stream.fromIterable([
        TVDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        TVDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: TVDetailState.initial(),
    );

    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: tId)));

    expect(snackbar, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackbar, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets('Show display snackBar when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockTVDetailBloc,
      Stream.fromIterable([
        TVDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        TVDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: TVDetailState.initial(),
    );

    final snackBarFinder = find.byType(SnackBar);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(snackBarFinder, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackBarFinder, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets(
      'TV detail page should display error text when no internet network',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Error,
        message: 'Failed to connect to the network',
      ),
    );

    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations TVs should display error text when data is empty',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: tTvDetail,
        tvRecommendationsState: RequestState.Empty,
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('No Recommendations');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations TVs should display error text when get data is unsuccesful',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: tTvDetail,
        tvRecommendationsState: RequestState.Error,
        message: 'Error',
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('Error');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets('Back button when click back to home page',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(
      TVDetailState.initial().copyWith(
        tvDetailState: RequestState.Loaded,
        tvDetail: tTvDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: false,
      ),
    );

    final buttonBack = find.byKey(const Key('iconBack'));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(buttonBack);
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));

    expect(buttonBack, findsNothing);
  });
}
