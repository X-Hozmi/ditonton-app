import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:tv/presentation/pages/nowplaying_tv_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTVBloc
    extends MockBloc<NowPlayingTVEvent, NowPlayingTVState>
    implements NowPlayingTVBloc {}

class FakeNowPlayingTVState extends Fake implements NowPlayingTVState {}

class FakeNowPlayingTVEvent extends Fake implements NowPlayingTVEvent {}

void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingTVState());
    registerFallbackValue(FakeNowPlayingTVEvent());
  });

  setUp(() {
    mockNowPlayingTVBloc = MockNowPlayingTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<NowPlayingTVBloc>.value(
        value: mockNowPlayingTVBloc,
        child: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      const NowPlayingTVState(
        state: RequestState.Loading,
        tv: [],
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      NowPlayingTVState(
        state: RequestState.Loaded,
        tv: tTvList,
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingTVPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      const NowPlayingTVState(
        state: RequestState.Error,
        tv: [],
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingTVPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty message when no data',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(
      const NowPlayingTVState(
        state: RequestState.Empty,
        tv: [],
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingTVPage()));

    expect(find.text('Empty data'), findsOneWidget);
  });
}
