import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/utils/routes.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display movie title and overview',
      (WidgetTester tester) async {
    // Arrange
    final movie = Movie(
      adult: false,
      backdropPath: '/path/to/backdrop.jpg',
      genreIds: const [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'This is the overview of the movie.',
      popularity: 10.0,
      posterPath: '/path/to/poster.jpg',
      releaseDate: '2024-08-04',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(movie),
        ),
      ),
    );

    // Assert
    expect(find.text('Movie Title'), findsOneWidget);
    expect(find.text('This is the overview of the movie.'), findsOneWidget);
  });

  testWidgets('should navigate to movie detail page when tapped',
      (WidgetTester tester) async {
    // Arrange
    final movie = Movie(
      adult: false,
      backdropPath: '/path/to/backdrop.jpg',
      genreIds: const [1, 2],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'This is the overview of the movie.',
      popularity: 10.0,
      posterPath: '/path/to/poster.jpg',
      releaseDate: '2024-08-04',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == MOVIE_DETAIL_ROUTE) {
            return MaterialPageRoute(
              builder: (context) => const Placeholder(),
            );
          }
          return null;
        },
        home: Scaffold(
          body: MovieCard(movie),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
