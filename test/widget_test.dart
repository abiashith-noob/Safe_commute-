
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_commute_ai/main.dart';

void main() {
  testWidgets('App renders sign in screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SafeCommuteApp());
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
