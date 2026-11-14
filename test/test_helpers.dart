import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/size_helper.dart';
import 'package:size_helper/src/screen_info.dart';

/// The 12 portrait option names, in the same order as the parameters.
const portraitNames = <String>[
  'mobileSmall',
  'mobileNormal',
  'mobileLarge',
  'mobileExtraLarge',
  'tabletSmall',
  'tabletNormal',
  'tabletLarge',
  'tabletExtraLarge',
  'desktopSmall',
  'desktopNormal',
  'desktopLarge',
  'desktopExtraLarge',
];

/// The 12 landscape option names (`<portraitName>Landscape`).
final landscapeNames = <String>{
  for (final name in portraitNames) '${name}Landscape',
};

/// Platforms where [SizeHelper] picks options by orientation.
final mobilePlatforms = TargetPlatformVariant(
  <TargetPlatform>{TargetPlatform.android, TargetPlatform.iOS},
);

/// Platforms where [SizeHelper] ignores orientation and only uses the width.
final nonMobilePlatforms = TargetPlatformVariant(<TargetPlatform>{
  TargetPlatform.macOS,
  TargetPlatform.windows,
  TargetPlatform.linux,
  TargetPlatform.fuchsia,
});

/// `SizeHelper.willDependOnOrientation` is computed once and then cached in a
/// static field, so every test must start (and end) from a clean state.
void resetSizeHelperPlatformCache() =>
    SizeHelper.willDependOnOrientation = null;

/// Sets the test view to [size] logical pixels.
void setLogicalSize(
  WidgetTester tester,
  Size size, {
  double devicePixelRatio = 1.0,
}) {
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = size * devicePixelRatio;
  addTearDown(tester.view.reset);
}

/// Builds a widget inside a real test view whose logical size is [size] and
/// returns what [compute] produced during that build.
Future<T> resolveAt<T>(
  WidgetTester tester,
  Size size,
  T Function(BuildContext context) compute, {
  double devicePixelRatio = 1.0,
}) async {
  setLogicalSize(tester, size, devicePixelRatio: devicePixelRatio);
  late T result;
  await tester.pumpWidget(
    Builder(
      builder: (context) {
        result = compute(context);
        return const SizedBox.shrink();
      },
    ),
  );
  return result;
}

/// A portrait-shaped size whose width is [width].
Size portrait(double width) => Size(width, width + 1000);

/// A landscape-shaped size whose height (the shorter side) is [height].
Size landscape(double height) => Size(height + 1000, height);

/// Calls [SizeHelper.help] with all 24 options, each option's value being its
/// own parameter name, except the names in [omit].
String helpWithAll(SizeHelper helper, {Set<String> omit = const {}}) {
  String? v(String name) => omit.contains(name) ? null : name;
  return helper.help<String>(
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

/// Calls [SizeHelper.helpBuilder] with all 24 options (except [omit]); each
/// builder returns its own parameter name and reports every call to [onCall].
String helpBuilderWithAll(
  SizeHelper helper, {
  Set<String> omit = const {},
  void Function(String name, ScreenInfo info)? onCall,
}) {
  HelpBuilderCallback<String>? b(String name) {
    if (omit.contains(name)) return null;
    return (info) {
      onCall?.call(name, info);
      return name;
    };
  }

  return helper.helpBuilder<String>(
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

/// Matches the exception thrown when no option can be selected.
final throwsNoOptionException = throwsA(
  isA<Exception>().having(
    (e) => e.toString(),
    'message',
    contains('Screen size not specified'),
  ),
);
