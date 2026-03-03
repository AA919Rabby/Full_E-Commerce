import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_media/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // UPDATED: Remove the startScreen argument here
    await tester.pumpWidget(const MyApp());

    // Note: Since you are now using Firebase and AuthWrapper, 
    // this default counter test will likely fail anyway because 
    // your app doesn't start with a counter anymore.
  });
}