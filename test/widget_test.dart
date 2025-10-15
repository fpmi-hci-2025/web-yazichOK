import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web/main.dart';

void main() {
  testWidgets('Hello World text is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hello World from Flutter!'), findsOneWidget);
    expect(find.text('Flutter Web'), findsOneWidget);
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(AppBar), findsOneWidget);
  });
}