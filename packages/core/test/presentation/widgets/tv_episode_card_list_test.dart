import 'package:core/domain/entities/tv/tv_episode.dart';
import 'package:core/presentation/widgets/tv_episode_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should display episode number, name, and overview',
      (WidgetTester tester) async {
    // Arrange
    const episode = Episode(
      airDate: '2024-08-04',
      episodeNumber: 1,
      id: 1,
      name: 'Episode Title',
      overview: 'This is the overview of the episode.',
      productionCode: 'PC123',
      seasonNumber: 1,
      stillPath: '/path/to/still.jpg',
      voteAverage: 9.0,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EpisodeCardList(episode: episode),
        ),
      ),
    );

    // Assert
    expect(find.text('Episode 1'), findsOneWidget);
    expect(find.text('Episode Title'), findsOneWidget);
    expect(find.text('This is the overview of the episode.'), findsOneWidget);
  });

  testWidgets('should display a placeholder when stillPath is null',
      (WidgetTester tester) async {
    // Arrange
    const episode = Episode(
      airDate: '2024-08-04',
      episodeNumber: 1,
      id: 1,
      name: 'Episode Title',
      overview: 'This is the overview of the episode.',
      productionCode: 'PC123',
      seasonNumber: 1,
      stillPath: null,
      voteAverage: 9.0,
      voteCount: 100,
    );

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EpisodeCardList(episode: episode),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
