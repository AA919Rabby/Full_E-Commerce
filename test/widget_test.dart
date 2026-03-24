import 'package:flutter_test/flutter_test.dart';
import 'package:social_media/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // This just verifies the app starts up.
    // Since you use Firebase, the test might still fail if it
    // tries to reach the network, but this is a better starting point.
    await tester.pumpWidget(const MyApp());
  });
}