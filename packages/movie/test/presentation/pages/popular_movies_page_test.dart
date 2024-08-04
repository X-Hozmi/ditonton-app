import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/popular/popular_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class FakePopularMoviesEvent extends Fake implements PopularMovieEvent {}

class FakePopularMoviesState extends Fake implements PopularMovieState {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(
      PopularMovieState.initial().copyWith(state: RequestState.Loading),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMovieState.initial().copyWith(
      state: RequestState.Loaded,
      movies: [testMovie],
    ));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(
      PopularMovieState.initial().copyWith(
        state: RequestState.Error,
        message: 'Error Message',
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when no data',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(
      PopularMovieState.initial().copyWith(
        state: RequestState.Empty,
      ),
    );

    final iconFinder = find.byIcon(Icons.question_mark);
    final textFinder = find.text('Empty data');

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(iconFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
