import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/size_helper.dart';

import 'package:example/main.dart';

Future<void> pumpAppAt(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MyApp());
}

void main() {
  tearDown(() => SizeHelper.willDependOnOrientation = null);

  testWidgets('a 390pt phone shows tabletSmall', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));
    expect(find.text('tabletSmall'), findsOneWidget);
    expect(find.text('390 x 844 portrait'), findsOneWidget);
  });

  testWidgets('a 13-inch iPad (1024x1366) shows desktopSmall', (tester) async {
    await pumpAppAt(tester, const Size(1024, 1366));
    expect(find.text('desktopSmall'), findsOneWidget);
    expect(find.text('1024 x 1366 portrait'), findsOneWidget);
  });

  testWidgets('rotating a phone keeps its breakpoint', (tester) async {
    await pumpAppAt(tester, const Size(844, 390));
    expect(find.text('tabletSmall'), findsOneWidget);
    expect(find.text('844 x 390 landscape'), findsOneWidget);
  });

  testWidgets('toggles between example 1 and example 2', (tester) async {
    await pumpAppAt(tester, const Size(1024, 1366));

    await tester.tap(find.text('Show example 2'));
    await tester.pumpAndSettle();
    expect(find.text('desktopSmall'), findsNothing);
    expect(find.text('Card 1'), findsOneWidget);
    expect(find.byType(Wrap), findsOneWidget);

    await tester.tap(find.text('Show example 1'));
    await tester.pumpAndSettle();
    expect(find.text('desktopSmall'), findsOneWidget);
  });

  testWidgets('example 2 lays cards out in a column on phones', (tester) async {
    await pumpAppAt(tester, const Size(390, 844));
    await tester.tap(find.text('Show example 2'));
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsWidgets);
    expect(find.byType(Wrap), findsNothing);
    expect(find.text('Card 1'), findsOneWidget);
  });
}
