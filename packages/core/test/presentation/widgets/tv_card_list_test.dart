import 'package:core/domain/entities/tv/tv.dart';
import 'package:core/utils/routes.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display TV title and overview',
      (WidgetTester tester) async {
    // Arrange
    final tv = TV(
      backdropPath: '/path/to/backdrop.jpg',
      firstAirDate: '2024-08-04',
      genreIds: const [1, 2],
      id: 1,
      originalName: 'Original Name',
      name: 'TV Show Title',
      originalLanguage: 'en',
      overview: 'This is the overview of the TV show.',
      popularity: 10.0,
      posterPath: '/path/to/poster.jpg',
      voteAverage: 8.5,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TVCard(tv),
        ),
      ),
    );

    // Assert
    expect(find.text('TV Show Title'), findsOneWidget);
    expect(find.text('This is the overview of the TV show.'), findsOneWidget);
  });

  testWidgets('should navigate to TV detail page when tapped',
      (WidgetTester tester) async {
    // Arrange
    final tv = TV(
      backdropPath: '/path/to/backdrop.jpg',
      firstAirDate: '2024-08-04',
      genreIds: const [1, 2],
      id: 1,
      originalName: 'Original Name',
      name: 'TV Show Title',
      originalLanguage: 'en',
      overview: 'This is the overview of the TV show.',
      popularity: 10.0,
      posterPath: '/path/to/poster.jpg',
      voteAverage: 8.5,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TVCard(tv),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == TV_DETAIL_ROUTE) {
            return MaterialPageRoute(
              builder: (context) => const Placeholder(),
            );
          }
          return null;
        },
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
