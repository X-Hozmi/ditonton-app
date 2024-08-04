import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/top_rated/top_rated_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTVBloc extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

class FakeTopRatedTVEvent extends Fake implements TopRatedTVEvent {}

class FakeTopRatedTVState extends Fake implements TopRatedTVState {}

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTVEvent());
    registerFallbackValue(FakeTopRatedTVState());
  });

  setUp(() {
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>.value(
      value: mockTopRatedTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState.initial().copyWith(state: RequestState.Loading),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVState.initial().copyWith(
      state: RequestState.Loaded,
      tv: tTvList,
    ));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Error Message',
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when no data',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state).thenReturn(
      TopRatedTVState.initial().copyWith(
        state: RequestState.Empty,
      ),
    );

    final iconFinder = find.byIcon(Icons.question_mark);
    final textFinder = find.text('Empty data');

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(iconFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
