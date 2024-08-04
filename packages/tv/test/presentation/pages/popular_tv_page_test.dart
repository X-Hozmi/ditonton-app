import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/popular/popular_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularTVBloc extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

class FakePopularTVEvent extends Fake implements PopularTVEvent {}

class FakePopularTVState extends Fake implements PopularTVState {}

void main() {
  late MockPopularTVBloc mockPopularTVBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTVEvent());
    registerFallbackValue(FakePopularTVState());
  });

  setUp(() {
    mockPopularTVBloc = MockPopularTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVBloc>.value(
      value: mockPopularTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState.initial().copyWith(state: RequestState.Loading),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVState.initial().copyWith(
      state: RequestState.Loaded,
      tv: tTvList,
    ));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState.initial().copyWith(
        state: RequestState.Error,
        message: 'Error Message',
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty message when no data',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state).thenReturn(
      PopularTVState.initial().copyWith(
        state: RequestState.Empty,
      ),
    );

    final iconFinder = find.byIcon(Icons.question_mark);
    final textFinder = find.text('Empty data');

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(iconFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}
