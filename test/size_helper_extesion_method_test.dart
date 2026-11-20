import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/size_helper.dart';
import 'package:size_helper/src/breakpoints.dart';

import 'test_helpers.dart';

/// `context.sizeHelper` with all 24 options, each returning its own name.
String _sizeHelperWithAll(
  BuildContext context, {
  Set<String> omit = const {},
  bool printScreenInfo = false,
}) {
  String? v(String name) => omit.contains(name) ? null : name;
  return context.sizeHelper<String>(
    printScreenInfo: printScreenInfo,
    mobileSmall: v('mobileSmall'),
    mobileSmallLandscape: v('mobileSmallLandscape'),
    mobileNormal: v('mobileNormal'),
    mobileNormalLandscape: v('mobileNormalLandscape'),
    mobileLarge: v('mobileLarge'),
    mobileLargeLandscape: v('mobileLargeLandscape'),
    mobileExtraLarge: v('mobileExtraLarge'),
    mobileExtraLargeLandscape: v('mobileExtraLargeLandscape'),
    tabletSmall: v('tabletSmall'),
    tabletSmallLandscape: v('tabletSmallLandscape'),
    tabletNormal: v('tabletNormal'),
    tabletNormalLandscape: v('tabletNormalLandscape'),
    tabletLarge: v('tabletLarge'),
    tabletLargeLandscape: v('tabletLargeLandscape'),
    tabletExtraLarge: v('tabletExtraLarge'),
    tabletExtraLargeLandscape: v('tabletExtraLargeLandscape'),
    desktopSmall: v('desktopSmall'),
    desktopSmallLandscape: v('desktopSmallLandscape'),
    desktopNormal: v('desktopNormal'),
    desktopNormalLandscape: v('desktopNormalLandscape'),
    desktopLarge: v('desktopLarge'),
    desktopLargeLandscape: v('desktopLargeLandscape'),
    desktopExtraLarge: v('desktopExtraLarge'),
    desktopExtraLargeLandscape: v('desktopExtraLargeLandscape'),
  );
}

/// `context.sizeHelperBuilder` with all 24 builders, each returning its name.
String _sizeHelperBuilderWithAll(
  BuildContext context, {
  Set<String> omit = const {},
  bool printScreenInfo = false,
  void Function(ScreenInfo info)? onCall,
}) {
  HelpBuilderCallback<String>? b(String name) {
    if (omit.contains(name)) return null;
    return (info) {
      onCall?.call(info);
      return name;
    };
  }

  return context.sizeHelperBuilder<String>(
    printScreenInfo: printScreenInfo,
    mobileSmall: b('mobileSmall'),
    mobileSmallLandscape: b('mobileSmallLandscape'),
    mobileNormal: b('mobileNormal'),
    mobileNormalLandscape: b('mobileNormalLandscape'),
    mobileLarge: b('mobileLarge'),
    mobileLargeLandscape: b('mobileLargeLandscape'),
    mobileExtraLarge: b('mobileExtraLarge'),
    mobileExtraLargeLandscape: b('mobileExtraLargeLandscape'),
    tabletSmall: b('tabletSmall'),
    tabletSmallLandscape: b('tabletSmallLandscape'),
    tabletNormal: b('tabletNormal'),
    tabletNormalLandscape: b('tabletNormalLandscape'),
    tabletLarge: b('tabletLarge'),
    tabletLargeLandscape: b('tabletLargeLandscape'),
    tabletExtraLarge: b('tabletExtraLarge'),
    tabletExtraLargeLandscape: b('tabletExtraLargeLandscape'),
    desktopSmall: b('desktopSmall'),
    desktopSmallLandscape: b('desktopSmallLandscape'),
    desktopNormal: b('desktopNormal'),
    desktopNormalLandscape: b('desktopNormalLandscape'),
    desktopLarge: b('desktopLarge'),
    desktopLargeLandscape: b('desktopLargeLandscape'),
    desktopExtraLarge: b('desktopExtraLarge'),
    desktopExtraLargeLandscape: b('desktopExtraLargeLandscape'),
  );
}

/// Sizes at which each of the 24 options is the one selected, when all 24 are
/// passed.
Map<String, Size> _sizeForEachOption() => {
      for (final b in BreakPoint.values) ...{
        b.name: portrait(b.value),
        '${b.name}Landscape': landscape(b.value),
      },
    };

void main() {
  setUp(resetSizeHelperPlatformCache);
  tearDown(resetSizeHelperPlatformCache);

  group('context.sizeHelper', () {
    for (final entry in _sizeForEachOption().entries) {
      testWidgets('forwards ${entry.key}', (tester) async {
        final result = await resolveAt(
          tester,
          entry.value,
          (context) => _sizeHelperWithAll(context),
        );
        expect(result, entry.key);
      });
    }

    testWidgets('matches SizeHelper.of(context).help', (tester) async {
      for (final width in [0.0, 300.0, 400.0, 700.0, 1100.0, 2000.0]) {
        final results = await resolveAt(
          tester,
          portrait(width),
          (context) => [
            _sizeHelperWithAll(context, omit: {'mobileLarge', 'tabletLarge'}),
            helpWithAll(
              SizeHelper.of(context),
              omit: {'mobileLarge', 'tabletLarge'},
            ),
          ],
        );
        expect(results.first, results.last, reason: 'width $width');
      }
    });

    testWidgets('forwards printScreenInfo without changing the result',
        (tester) async {
      final result = await resolveAt(
        tester,
        portrait(320),
        (context) => _sizeHelperWithAll(context, printScreenInfo: true),
      );
      expect(result, 'mobileNormal');
    });

    testWidgets('falls back to the closest option', (tester) async {
      final result = await resolveAt(
        tester,
        portrait(1400),
        (context) => context.sizeHelper(mobileLarge: 1, tabletNormal: 2),
      );
      expect(result, 2);
    });

    testWidgets('throws when no option is passed', (tester) async {
      await resolveAt(tester, portrait(320), (context) {
        expect(() => context.sizeHelper<int>(), throwsNoOptionException);
        return null;
      });
    });
  });

  group('context.sizeHelperBuilder', () {
    for (final entry in _sizeForEachOption().entries) {
      testWidgets('forwards ${entry.key}', (tester) async {
        final result = await resolveAt(
          tester,
          entry.value,
          (context) => _sizeHelperBuilderWithAll(context),
        );
        expect(result, entry.key);
      });
    }

    testWidgets('forwards printScreenInfo and passes ScreenInfo',
        (tester) async {
      final infos = <ScreenInfo>[];
      final result = await resolveAt(
        tester,
        const Size(700, 320),
        (context) => _sizeHelperBuilderWithAll(
          context,
          printScreenInfo: true,
          onCall: infos.add,
        ),
      );
      expect(result, 'mobileNormalLandscape');
      expect(infos, hasLength(1));
      expect(infos.single.width, 700);
      expect(infos.single.height, 320);
      expect(infos.single.orientation, Orientation.landscape);
    });

    testWidgets('builds the selected widget', (tester) async {
      setLogicalSize(tester, portrait(1200));
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) => context.sizeHelperBuilder(
              mobileExtraLarge: (_) => const Text('column'),
              tabletLarge: (_) => const Text('row'),
              desktopSmall: (info) => Text('wrap ${info.width.round()}'),
            ),
          ),
        ),
      );
      expect(find.text('wrap 1200'), findsOneWidget);
      expect(find.text('column'), findsNothing);
      expect(find.text('row'), findsNothing);
    });

    testWidgets('throws when no builder is passed', (tester) async {
      await resolveAt(tester, portrait(320), (context) {
        expect(
          () => context.sizeHelperBuilder<int>(),
          throwsNoOptionException,
        );
        return null;
      });
    });
  });
}
