import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';

import 'package:ditonton/main.dart' as app;

void main() {
  group('Testing App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final watchlistButton = find.byKey(Key('watchlistButton'));
    final iconCheck = find.byIcon(Icons.check);
    final iconBack = find.byKey(Key('iconBack'));
    final iconMenuWatchlist = find.byIcon(Icons.remove_red_eye);

    testWidgets('Verify watchlist', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final movieItem = find.byKey(Key('itemFilm')).first;
      await tester.tap(movieItem);
      await tester.pumpAndSettle();

      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      await tester.tap(iconMenuWatchlist);
      await tester.pumpAndSettle();

      expect(find.byType(MovieCard), findsOneWidget);

      final iconMenuTvSeries = find.byIcon(Icons.live_tv_outlined);
      await tester.tap(iconMenuTvSeries);
      await tester.pumpAndSettle();

      final tvSeriesItem = find.byKey(Key('itemTV')).first;
      await tester.tap(tvSeriesItem);
      await tester.pumpAndSettle();

      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      await tester.tap(iconMenuWatchlist);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('tabDaftarTonton')));
      await tester.pumpAndSettle();
      expect(find.byType(TVCard), findsOneWidget);
    });
  });
}
