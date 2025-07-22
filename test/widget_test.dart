import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pifibantayapp/main.dart'; // Adjust if your package name is different

void main() {
  testWidgets('App loads and shows AppBar title', (WidgetTester tester) async {
    await tester.pumpWidget(PiFiBantayApp());

    // Check if the AppBar title is visible
    expect(find.text('PiFiBantay'), findsOneWidget);

    // Check if bottom navigation is visible
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.warning), findsOneWidget);
  });
}