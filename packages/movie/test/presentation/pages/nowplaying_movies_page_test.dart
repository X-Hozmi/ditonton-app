import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/nowplaying/nowplaying_bloc.dart';
import 'package:movie/presentation/pages/nowplaying_movies_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

class FakeNowPlayingMovieState extends Fake implements NowPlayingMovieState {}

class FakeNowPlayingMovieEvent extends Fake implements NowPlayingMovieEvent {}

void main() {
  late MockNowPlayingMovieBloc mockNowPlayingMovieBloc;

  setUpAll(() {
    registerFallbackValue(FakeNowPlayingMovieState());
    registerFallbackValue(FakeNowPlayingMovieEvent());
  });

  setUp(() {
    mockNowPlayingMovieBloc = MockNowPlayingMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<NowPlayingMovieBloc>.value(
        value: mockNowPlayingMovieBloc,
        child: body,
      ),
    );
  }

  final testMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    releaseDate: '2021-01-01',
    title: 'Title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final testMovieList = [testMovie];

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(
        state: RequestState.Loading,
        movies: [],
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      NowPlayingMovieState(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingMoviePage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(
        state: RequestState.Error,
        movies: [],
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingMoviePage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty message when no data',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMovieBloc.state).thenReturn(
      const NowPlayingMovieState(
        state: RequestState.Empty,
        movies: [],
        message: '',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const NowplayingMoviePage()));

    expect(find.text('Empty data'), findsOneWidget);
  });
}
