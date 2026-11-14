import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/size_helper.dart';
import 'package:size_helper/src/breakpoints.dart';
import 'package:size_helper/src/screen_info.dart';

import 'test_helpers.dart';

/// A selection boundary when every portrait option is passed: halfway between
/// two neighbouring breakpoint values. An exact tie goes to the smaller
/// breakpoint, because it comes first in [BreakPoint.values].
class _Boundary {
  const _Boundary(this.at, this.below, this.above);

  final double at;
  final String below;
  final String above;
}

const _midpoints = <_Boundary>[
  _Boundary(300.0, 'mobileSmall', 'mobileNormal'),
  _Boundary(337.5, 'mobileNormal', 'mobileLarge'),
  _Boundary(362.5, 'mobileLarge', 'mobileExtraLarge'),
  _Boundary(387.5, 'mobileExtraLarge', 'tabletSmall'),
  // tabletSmall and tabletNormal are both 400.0, so tabletSmall always wins.
  _Boundary(425.0, 'tabletSmall', 'tabletLarge'),
  _Boundary(525.0, 'tabletLarge', 'tabletExtraLarge'),
  _Boundary(775.0, 'tabletExtraLarge', 'desktopSmall'),
  _Boundary(1050.0, 'desktopSmall', 'desktopNormal'),
  _Boundary(1325.0, 'desktopNormal', 'desktopLarge'),
  _Boundary(1650.0, 'desktopLarge', 'desktopExtraLarge'),
];

/// The option expected when the length equals [breakPoint]'s value.
String _expectedAt(BreakPoint breakPoint) =>
    // tabletNormal shares 400.0 with tabletSmall, which comes first.
    breakPoint == BreakPoint.tabletNormal ? 'tabletSmall' : breakPoint.name;

void main() {
  setUp(resetSizeHelperPlatformCache);
  tearDown(resetSizeHelperPlatformCache);

  group('help - portrait breakpoints (all 12 portrait options passed)', () {
    for (final breakPoint in BreakPoint.values) {
      final value = breakPoint.value;
      testWidgets(
        '${breakPoint.name}: at $value, just below and just above',
        (tester) async {
          for (final width in [value - 0.5, value, value + 0.5]) {
            final result = await resolveAt(
              tester,
              portrait(width),
              (context) => helpWithAll(
                SizeHelper.of(context),
                omit: landscapeNames,
              ),
            );
            expect(result, _expectedAt(breakPoint), reason: 'width $width');
          }
        },
        variant: TargetPlatformVariant.all(),
      );
    }

    for (final boundary in _midpoints) {
      testWidgets(
        '${boundary.below} -> ${boundary.above} boundary at ${boundary.at}',
        (tester) async {
          Future<String> at(double width) => resolveAt(
                tester,
                portrait(width),
                (context) => helpWithAll(
                  SizeHelper.of(context),
                  omit: landscapeNames,
                ),
              );

          expect(await at(boundary.at - 0.5), boundary.below);
          expect(await at(boundary.at), boundary.below, reason: 'tie');
          expect(await at(boundary.at + 0.5), boundary.above);
        },
        variant: TargetPlatformVariant.all(),
      );
    }

    testWidgets('widths far outside the range clamp to the extremes',
        (tester) async {
      Future<String> at(double width) => resolveAt(
            tester,
            portrait(width),
            (context) =>
                helpWithAll(SizeHelper.of(context), omit: landscapeNames),
          );

      expect(await at(0), 'mobileSmall');
      expect(await at(1), 'mobileSmall');
      expect(await at(5000), 'desktopExtraLarge');
    });

    // Known bug: tabletSmall and tabletNormal are both 400.0
    // (lib/src/breakpoints.dart:11-12), so `tabletNormal` is unreachable
    // whenever `tabletSmall` is passed too. testWidgets only takes a bool
    // `skip`; the string reason lives on the matching test in
    // breakpoints_test.dart.
    testWidgets(
      'tabletNormal is selectable when tabletSmall is also passed',
      (tester) async {
        // Both breakpoints are 400.0, so the closest-breakpoint search can
        // never prefer tabletNormal over tabletSmall.
        final result = await resolveAt(
          tester,
          portrait(BreakPoint.tabletNormal.value),
          (context) =>
              helpWithAll(SizeHelper.of(context), omit: landscapeNames),
        );
        expect(result, 'tabletNormal');
      },
      skip: true, // Known bug, see the comment above.
    );

    testWidgets('tabletNormal is selected when tabletSmall is not passed',
        (tester) async {
      final result = await resolveAt(
        tester,
        portrait(400),
        (context) => helpWithAll(
          SizeHelper.of(context),
          omit: {...landscapeNames, 'tabletSmall'},
        ),
      );
      expect(result, 'tabletNormal');
    });
  });

  group('help - landscape on mobile (uses the height)', () {
    for (final breakPoint in BreakPoint.values) {
      final value = breakPoint.value;
      testWidgets(
        '${breakPoint.name}Landscape: height at $value, just below and above',
        (tester) async {
          for (final height in [value - 0.5, value, value + 0.5]) {
            final result = await resolveAt(
              tester,
              landscape(height),
              (context) => helpWithAll(SizeHelper.of(context)),
            );
            expect(
              result,
              '${_expectedAt(breakPoint)}Landscape',
              reason: 'height $height',
            );
          }
        },
        variant: mobilePlatforms,
      );
    }

    testWidgets(
      'landscape boundaries use the height',
      (tester) async {
        for (final boundary in _midpoints) {
          Future<String> at(double height) => resolveAt(
                tester,
                landscape(height),
                (context) => helpWithAll(SizeHelper.of(context)),
              );

          expect(await at(boundary.at - 0.5), '${boundary.below}Landscape');
          expect(await at(boundary.at), '${boundary.below}Landscape');
          expect(await at(boundary.at + 0.5), '${boundary.above}Landscape');
        }
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'portrait options are used in portrait even when landscape ones exist',
      (tester) async {
        final result = await resolveAt(
          tester,
          const Size(390, 844),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(result, 'tabletSmall');
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'a square screen counts as portrait; one pixel wider is landscape',
      (tester) async {
        final square = await resolveAt(
          tester,
          const Size(400, 400),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(square, 'tabletSmall');

        final wider = await resolveAt(
          tester,
          const Size(401, 400),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(wider, 'tabletSmallLandscape');
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'rotating a phone keeps the breakpoint (shorter side) but switches map',
      (tester) async {
        String pick(BuildContext context) => SizeHelper.of(context).help(
              mobileExtraLarge: 'phone portrait',
              mobileExtraLargeLandscape: 'phone landscape',
              desktopLarge: 'desktop portrait',
              desktopLargeLandscape: 'desktop landscape',
            );

        expect(await resolveAt(tester, const Size(375, 812), pick),
            'phone portrait');
        expect(await resolveAt(tester, const Size(812, 375), pick),
            'phone landscape');
      },
      variant: mobilePlatforms,
    );
  });

  group('help - non-mobile platforms ignore orientation', () {
    testWidgets(
      'a landscape-shaped window uses the width and portrait options',
      (tester) async {
        final result = await resolveAt(
          tester,
          const Size(1920, 1080),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(result, 'desktopExtraLarge');
      },
      variant: nonMobilePlatforms,
    );

    testWidgets(
      'the same window on mobile uses the height and landscape options',
      (tester) async {
        final result = await resolveAt(
          tester,
          const Size(1920, 1080),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(result, 'desktopNormalLandscape');
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'landscape options are only used as a fallback',
      (tester) async {
        final result = await resolveAt(
          tester,
          const Size(1920, 1080),
          (context) => SizeHelper.of(context).help(
            mobileSmallLandscape: 'landscape only',
          ),
        );
        expect(result, 'landscape only');
      },
      variant: nonMobilePlatforms,
    );

    testWidgets(
      'landscape boundaries are width based on non-mobile platforms',
      (tester) async {
        for (final boundary in _midpoints) {
          Future<String> at(double width) => resolveAt(
                tester,
                Size(width, 100),
                (context) =>
                    helpWithAll(SizeHelper.of(context), omit: landscapeNames),
              );

          expect(await at(boundary.at), boundary.below);
          expect(await at(boundary.at + 0.5), boundary.above);
        }
      },
      variant: nonMobilePlatforms,
    );
  });

  group('help - fallback to the closest passed option', () {
    testWidgets('README example: tabletLarge falls back to tabletNormal',
        (tester) async {
      final result = await resolveAt(
        tester,
        portrait(BreakPoint.tabletLarge.value),
        (context) => SizeHelper.of(context).help(
          mobileLarge: 14.0,
          tabletNormal: 18.0,
          desktopSmall: 21.0,
        ),
      );
      expect(result, 18.0);
    });

    testWidgets('picks the nearest value, not the next smaller breakpoint',
        (tester) async {
      String pick(BuildContext context) => SizeHelper.of(context).help(
            mobileSmall: 'mobileSmall',
            desktopNormal: 'desktopNormal',
          );

      // 1000 is below desktopNormal (1150) but much closer to it than to 275.
      expect(await resolveAt(tester, portrait(1000), pick), 'desktopNormal');
      // 700 is 425 away from 275 and 450 away from 1150.
      expect(await resolveAt(tester, portrait(700), pick), 'mobileSmall');
      // 712.5 is a tie (437.5 each way): the smaller breakpoint wins.
      expect(await resolveAt(tester, portrait(712.5), pick), 'mobileSmall');
      expect(await resolveAt(tester, portrait(713), pick), 'desktopNormal');
    });

    testWidgets('a single option is returned for every size', (tester) async {
      for (final width in [0.0, 320.0, 800.0, 3000.0]) {
        final result = await resolveAt(
          tester,
          portrait(width),
          (context) => SizeHelper.of(context).help(tabletLarge: 42),
        );
        expect(result, 42, reason: 'width $width');
      }
    });

    testWidgets(
      'portrait on mobile falls back to landscape options',
      (tester) async {
        final result = await resolveAt(
          tester,
          portrait(320),
          (context) => SizeHelper.of(context).help(
            mobileNormalLandscape: 'mobileNormalLandscape',
            desktopLargeLandscape: 'desktopLargeLandscape',
          ),
        );
        expect(result, 'mobileNormalLandscape');
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'landscape on mobile falls back to portrait options',
      (tester) async {
        final result = await resolveAt(
          tester,
          landscape(320),
          (context) => SizeHelper.of(context).help(
            mobileNormal: 'mobileNormal',
            desktopLarge: 'desktopLarge',
          ),
        );
        expect(result, 'mobileNormal');
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'an option for the current orientation beats a closer one for the other',
      (tester) async {
        // Landscape 1920x1080: length 1080 is far closer to desktopNormal
        // (1150) than to mobileSmall (275), but landscape options come first.
        final result = await resolveAt(
          tester,
          const Size(1920, 1080),
          (context) => SizeHelper.of(context).help(
            mobileSmallLandscape: 'mobileSmallLandscape',
            desktopNormal: 'desktopNormal',
          ),
        );
        expect(result, 'mobileSmallLandscape');
      },
      variant: mobilePlatforms,
    );

    testWidgets('explicit null options are treated as not passed',
        (tester) async {
      final result = await resolveAt(
        tester,
        portrait(BreakPoint.mobileSmall.value),
        (context) => SizeHelper.of(context).help<String?>(
          mobileSmall: null,
          desktopExtraLarge: 'desktopExtraLarge',
        ),
      );
      expect(result, 'desktopExtraLarge');
    });

    testWidgets('works with any data type', (tester) async {
      final result = await resolveAt(
        tester,
        portrait(360),
        (context) => SizeHelper.of(context).help(
          mobileLarge: const EdgeInsets.all(8),
          tabletNormal: const EdgeInsets.all(16),
        ),
      );
      expect(result, const EdgeInsets.all(8));
    });
  });

  group('help - no closest breakpoint found', () {
    testWidgets('throws when no option is passed (portrait)', (tester) async {
      final helper = await resolveAt(
        tester,
        portrait(320),
        (context) => SizeHelper.of(context),
      );
      expect(() => helper.help<String>(), throwsNoOptionException);
    });

    testWidgets(
      'throws when no option is passed (landscape) and names the orientation',
      (tester) async {
        final helper = await resolveAt(
          tester,
          landscape(320),
          (context) => SizeHelper.of(context),
        );
        expect(
          () => helper.help<String>(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              allOf(contains('320.0'), contains('Orientation.landscape')),
            ),
          ),
        );
      },
      variant: mobilePlatforms,
    );

    testWidgets('throws when every passed option is null', (tester) async {
      final helper = await resolveAt(
        tester,
        portrait(320),
        (context) => SizeHelper.of(context),
      );
      expect(
        () => helper.help<String?>(mobileSmall: null, desktopLarge: null),
        throwsNoOptionException,
      );
    });
  });

  group('help - cached breakpoint order', () {
    testWidgets('repeated calls at the same size use their own options',
        (tester) async {
      final helper = await resolveAt(
        tester,
        portrait(320),
        (context) => SizeHelper.of(context),
      );

      expect(helper.help(mobileNormal: 'a', desktopLarge: 'b'), 'a');
      // Second call hits the cache; its options must still be honoured.
      expect(helper.help(desktopLarge: 'only b'), 'only b');
      expect(helper.help(mobileSmall: 1, mobileNormal: 2), 2);
    });

    testWidgets('alternating sizes are not served from a stale cache',
        (tester) async {
      String pick(BuildContext context) => SizeHelper.of(context).help(
            mobileNormal: 'small',
            desktopLarge: 'large',
          );

      for (var i = 0; i < 3; i++) {
        expect(await resolveAt(tester, portrait(320), pick), 'small');
        expect(await resolveAt(tester, portrait(1500), pick), 'large');
      }
    });

    testWidgets(
      'same length in another orientation is not served from the cache',
      (tester) async {
        String pick(BuildContext context) => SizeHelper.of(context).help(
              mobileNormal: 'portrait',
              mobileNormalLandscape: 'landscape',
            );

        expect(await resolveAt(tester, const Size(320, 700), pick), 'portrait');
        expect(
            await resolveAt(tester, const Size(700, 320), pick), 'landscape');
        expect(await resolveAt(tester, const Size(320, 700), pick), 'portrait');
      },
      variant: mobilePlatforms,
    );
  });

  group('printScreenInfo', () {
    testWidgets(
      'does not change the result above, at and below the breakpoint',
      (tester) async {
        // Lengths above, equal to and below the closest breakpoint (325).
        for (final width in [330.0, 325.0, 320.0]) {
          final result = await resolveAt(
            tester,
            portrait(width),
            (context) => SizeHelper.of(context, printScreenInfo: true).help(
              mobileNormal: 'help',
            ),
          );
          expect(result, 'help');

          final built = await resolveAt(
            tester,
            landscape(width),
            (context) =>
                SizeHelper.of(context, printScreenInfo: true).helpBuilder(
              mobileNormal: (_) => 'helpBuilder',
            ),
          );
          expect(built, 'helpBuilder');
        }
      },
      variant: mobilePlatforms,
    );
  });

  group('helpBuilder', () {
    for (final breakPoint in BreakPoint.values) {
      testWidgets('${breakPoint.name} and ${breakPoint.name}Landscape',
          (tester) async {
        final portraitResult = await resolveAt(
          tester,
          portrait(breakPoint.value),
          (context) => helpBuilderWithAll(SizeHelper.of(context)),
        );
        expect(portraitResult, _expectedAt(breakPoint));

        final landscapeResult = await resolveAt(
          tester,
          landscape(breakPoint.value),
          (context) => helpBuilderWithAll(SizeHelper.of(context)),
        );
        expect(landscapeResult, '${_expectedAt(breakPoint)}Landscape');
      });
    }

    testWidgets('tabletNormal builders are used when tabletSmall is absent',
        (tester) async {
      final omit = {'tabletSmall', 'tabletSmallLandscape'};
      expect(
        await resolveAt(
          tester,
          portrait(400),
          (context) => helpBuilderWithAll(SizeHelper.of(context), omit: omit),
        ),
        'tabletNormal',
      );
      expect(
        await resolveAt(
          tester,
          landscape(400),
          (context) => helpBuilderWithAll(SizeHelper.of(context), omit: omit),
        ),
        'tabletNormalLandscape',
      );
    });

    testWidgets('only the selected builder is invoked, exactly once',
        (tester) async {
      final calls = <String>[];
      await resolveAt(
        tester,
        portrait(1150),
        (context) => helpBuilderWithAll(
          SizeHelper.of(context),
          onCall: (name, _) => calls.add(name),
        ),
      );
      expect(calls, ['desktopNormal']);
    });

    testWidgets('falls back to the closest builder', (tester) async {
      final result = await resolveAt(
        tester,
        portrait(450),
        (context) => SizeHelper.of(context).helpBuilder(
          mobileLarge: (_) => 'mobileLarge',
          tabletNormal: (_) => 'tabletNormal',
          desktopSmall: (_) => 'desktopSmall',
        ),
      );
      expect(result, 'tabletNormal');
    });

    testWidgets('throws when no builder is passed', (tester) async {
      final helper = await resolveAt(
        tester,
        portrait(320),
        (context) => SizeHelper.of(context),
      );
      expect(() => helper.helpBuilder<String>(), throwsNoOptionException);
    });

    testWidgets('accepts a HelpBuilderCallback variable', (tester) async {
      final HelpBuilderCallback<int> callback =
          (info) => (info.width * 2).round();
      final result = await resolveAt(
        tester,
        portrait(300),
        (context) => SizeHelper.of(context).helpBuilder(mobileSmall: callback),
      );
      expect(result, 600);
    });
  });

  group('helpBuilder - ScreenInfo', () {
    Future<ScreenInfo> infoAt(
      WidgetTester tester,
      Size size, {
      double devicePixelRatio = 1.0,
    }) =>
        resolveAt(
          tester,
          size,
          (context) => SizeHelper.of(context).helpBuilder(
            mobileSmall: (info) => info,
          ),
          devicePixelRatio: devicePixelRatio,
        );

    testWidgets(
      'portrait phone: logical width, height and portrait orientation',
      (tester) async {
        final info = await infoAt(
          tester,
          const Size(390, 844),
          devicePixelRatio: 3.0,
        );
        expect(info.width, 390);
        expect(info.height, 844);
        expect(info.orientation, Orientation.portrait);
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'landscape phone: full width/height and landscape orientation',
      (tester) async {
        final info = await infoAt(tester, const Size(844, 390));
        expect(info.width, 844);
        expect(info.height, 390);
        expect(info.orientation, Orientation.landscape);
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'non-mobile platforms always report portrait, even for wide windows',
      (tester) async {
        final info = await infoAt(tester, const Size(1920, 1080));
        expect(info.width, 1920);
        expect(info.height, 1080);
        expect(info.orientation, Orientation.portrait);
      },
      variant: nonMobilePlatforms,
    );

    test('is a plain value holder', () {
      const info = ScreenInfo(
        width: 1.5,
        height: 2.5,
        orientation: Orientation.landscape,
      );
      expect(info.width, 1.5);
      expect(info.height, 2.5);
      expect(info.orientation, Orientation.landscape);
    });
  });

  group('SizeHelper.of', () {
    testWidgets('uses the logical size, not the physical size', (tester) async {
      // 1170x2532 physical pixels at 3.0 is a 390x844 logical phone.
      final result = await resolveAt(
        tester,
        const Size(390, 844),
        (context) => helpWithAll(SizeHelper.of(context), omit: landscapeNames),
        devicePixelRatio: 3.0,
      );
      expect(tester.view.physicalSize, const Size(1170, 2532));
      expect(result, 'tabletSmall');
    });

    testWidgets('uses the nearest MediaQuery ancestor', (tester) async {
      setLogicalSize(tester, portrait(320));
      late String result;
      await tester.pumpWidget(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(size: portrait(1500)),
            child: Builder(
              builder: (context) {
                result = SizeHelper.of(context).help(
                  mobileNormal: 'outer view size',
                  desktopLarge: 'overridden size',
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, 'overridden size');
    });

    testWidgets('rebuilds dependents when the size changes', (tester) async {
      setLogicalSize(tester, portrait(320));
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) => SizeHelper.of(context).helpBuilder(
              mobileNormal: (info) => Text('phone ${info.width}'),
              desktopLarge: (info) => Text('desktop ${info.width}'),
            ),
          ),
        ),
      );
      expect(find.text('phone 320.0'), findsOneWidget);

      tester.view.physicalSize = portrait(1500);
      await tester.pump();
      expect(find.text('phone 320.0'), findsNothing);
      expect(find.text('desktop 1500.0'), findsOneWidget);
    });

    testWidgets(
      'rotation swaps the widget built by helpBuilder',
      (tester) async {
        setLogicalSize(tester, const Size(390, 844));
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) => SizeHelper.of(context).helpBuilder(
                tabletSmall: (_) => const Text('portrait layout'),
                tabletSmallLandscape: (_) => const Text('landscape layout'),
              ),
            ),
          ),
        );
        expect(find.text('portrait layout'), findsOneWidget);

        tester.view.physicalSize = const Size(844, 390);
        await tester.pump();
        expect(find.text('portrait layout'), findsNothing);
        expect(find.text('landscape layout'), findsOneWidget);
      },
      variant: mobilePlatforms,
    );

    testWidgets('does not rebuild for unrelated MediaQuery changes',
        (tester) async {
      setLogicalSize(tester, portrait(320));
      var builds = 0;
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            builds++;
            SizeHelper.of(context).help(mobileNormal: 0);
            return const SizedBox.shrink();
          },
        ),
      );
      expect(builds, 1);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await tester.pump();
      expect(builds, 1, reason: 'only the size aspect is depended on');

      tester.view.physicalSize = portrait(330);
      await tester.pump();
      expect(builds, 2);
    });
  });

  group('platform detection (willDependOnOrientation)', () {
    testWidgets(
      'is true on Android and iOS',
      (tester) async {
        await resolveAt(tester, portrait(320), SizeHelper.of);
        expect(SizeHelper.willDependOnOrientation, isTrue);
      },
      variant: mobilePlatforms,
    );

    testWidgets(
      'is false on macOS, Windows, Linux and Fuchsia',
      (tester) async {
        await resolveAt(tester, portrait(320), SizeHelper.of);
        expect(SizeHelper.willDependOnOrientation, isFalse);
      },
      variant: nonMobilePlatforms,
    );

    testWidgets('is computed once and then cached', (tester) async {
      await resolveAt(tester, portrait(320), SizeHelper.of);
      expect(SizeHelper.willDependOnOrientation, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      try {
        await resolveAt(tester, portrait(320), SizeHelper.of);
        expect(SizeHelper.willDependOnOrientation, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('can be overridden to ignore orientation on mobile',
        (tester) async {
      SizeHelper.willDependOnOrientation = false;
      final result = await resolveAt(
        tester,
        const Size(1920, 1080),
        (context) => helpWithAll(SizeHelper.of(context)),
      );
      expect(result, 'desktopExtraLarge');
    });

    testWidgets(
      'can be overridden to use orientation on desktop',
      (tester) async {
        SizeHelper.willDependOnOrientation = true;
        final result = await resolveAt(
          tester,
          const Size(1920, 1080),
          (context) => helpWithAll(SizeHelper.of(context)),
        );
        expect(result, 'desktopNormalLandscape');
      },
      variant: nonMobilePlatforms,
    );
  });
}
