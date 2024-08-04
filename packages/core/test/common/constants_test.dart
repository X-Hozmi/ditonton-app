import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Text styles should apply correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: kTextTheme,
        ),
        home: Scaffold(
          body: Column(
            children: [
              Text('Heading 5', style: kTextTheme.headlineSmall),
              Text('Heading 6', style: kTextTheme.titleLarge),
              Text('Subtitle', style: kTextTheme.titleMedium),
              Text('Body Text', style: kTextTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );

    // Verify that the text styles are applied correctly
    final heading5Finder = find.text('Heading 5');
    final heading6Finder = find.text('Heading 6');
    final subtitleFinder = find.text('Subtitle');
    final bodyTextFinder = find.text('Body Text');

    expect(heading5Finder, findsOneWidget);
    expect(heading6Finder, findsOneWidget);
    expect(subtitleFinder, findsOneWidget);
    expect(bodyTextFinder, findsOneWidget);

    final heading5Text = tester.widget<Text>(heading5Finder);
    final heading6Text = tester.widget<Text>(heading6Finder);
    final subtitleText = tester.widget<Text>(subtitleFinder);
    final bodyText = tester.widget<Text>(bodyTextFinder);

    expect(heading5Text.style?.fontSize, 23);
    expect(heading5Text.style?.fontWeight, FontWeight.w400);

    expect(heading6Text.style?.fontSize, 19);
    expect(heading6Text.style?.fontWeight, FontWeight.w500);
    expect(heading6Text.style?.letterSpacing, 0.15);

    expect(subtitleText.style?.fontSize, 15);
    expect(subtitleText.style?.fontWeight, FontWeight.w400);
    expect(subtitleText.style?.letterSpacing, 0.15);

    expect(bodyText.style?.fontSize, 13);
    expect(bodyText.style?.fontWeight, FontWeight.w400);
    expect(bodyText.style?.letterSpacing, 0.25);
  });
}
