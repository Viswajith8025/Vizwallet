import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/features/splash/presentation/splash_screen.dart';

void main() {
  testWidgets('Viswallet splash shows brand', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(VisWalletLogo), findsOneWidget);
    expect(find.byType(VisWalletWordmark), findsOneWidget);
  });
}
