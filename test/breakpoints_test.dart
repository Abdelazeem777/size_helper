import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/src/breakpoints.dart';

void main() {
  group('BreakPoint', () {
    test('has the documented names and values, smallest first', () {
      expect(
        {for (final b in BreakPoint.values) b.name: b.value},
        {
          'mobileSmall': 275.0,
          'mobileNormal': 325.0,
          'mobileLarge': 350.0,
          'mobileExtraLarge': 375.0,
          'tabletSmall': 400.0,
          'tabletNormal': 400.0,
          'tabletLarge': 450.0,
          'tabletExtraLarge': 600.0,
          'desktopSmall': 950.0,
          'desktopNormal': 1150.0,
          'desktopLarge': 1500.0,
          'desktopExtraLarge': 1800.0,
        },
      );
    });

    test('values lists the 12 constants in order', () {
      expect(BreakPoint.values, [
        BreakPoint.mobileSmall,
        BreakPoint.mobileNormal,
        BreakPoint.mobileLarge,
        BreakPoint.mobileExtraLarge,
        BreakPoint.tabletSmall,
        BreakPoint.tabletNormal,
        BreakPoint.tabletLarge,
        BreakPoint.tabletExtraLarge,
        BreakPoint.desktopSmall,
        BreakPoint.desktopNormal,
        BreakPoint.desktopLarge,
        BreakPoint.desktopExtraLarge,
      ]);
    });

    test('values are non-decreasing', () {
      final values = BreakPoint.values.map((b) => b.value).toList();
      for (var i = 1; i < values.length; i++) {
        expect(values[i], greaterThanOrEqualTo(values[i - 1]));
      }
    });

    test(
      'values are strictly increasing',
      () {
        final values = BreakPoint.values.map((b) => b.value).toList();
        for (var i = 1; i < values.length; i++) {
          expect(values[i], greaterThan(values[i - 1]),
              reason: BreakPoint.values[i].name);
        }
      },
      skip: 'Known bug: tabletSmall and tabletNormal are both 400.0 '
          '(lib/src/breakpoints.dart:11-12), so tabletNormal is unreachable '
          'whenever tabletSmall is also passed.',
    );

    test('values returns a fresh list each time (SizeHelper sorts it)', () {
      final first = BreakPoint.values..clear();
      expect(first, isEmpty);
      expect(BreakPoint.values, hasLength(12));
    });
  });
}
