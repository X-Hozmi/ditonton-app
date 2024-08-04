import 'package:flutter/material.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/detail/detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Loaded,
        movieRecommendations: [testMovie],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Show display snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));

    expect(snackbar, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackbar, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets('Show display snackBar when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    final snackBarFinder = find.byType(SnackBar);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(snackBarFinder, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackBarFinder, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets(
      'Movie detail page should display error text when no internet network',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Error,
        message: 'Failed to connect to the network',
      ),
    );

    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Movies should display error text when data is empty',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Empty,
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('No Recommendations');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendations Movies should display error text when get data is unsuccesful',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Error,
        message: 'Error',
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('Error');

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets('Back button when click back to home page',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    final buttonBack = find.byKey(const Key('iconBack'));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(buttonBack);
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));

    expect(buttonBack, findsNothing);
  });
}
