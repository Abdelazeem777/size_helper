// Run with: flutter test --platform chrome test/size_helper_web_test.dart
@TestOn('browser')
library size_helper_web_test;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_helper/size_helper.dart';

import 'test_helpers.dart';

void main() {
  setUp(resetSizeHelperPlatformCache);
  tearDown(resetSizeHelperPlatformCache);

  test('runs on the web', () => expect(kIsWeb, isTrue));

  testWidgets(
    'web ignores orientation on every platform, mobile browsers included',
    (tester) async {
      final result = await resolveAt(
        tester,
        const Size(1920, 1080),
        (context) => helpWithAll(SizeHelper.of(context)),
      );
      expect(SizeHelper.willDependOnOrientation, isFalse);
      expect(result, 'desktopExtraLarge');

      final info = await resolveAt(
        tester,
        const Size(844, 390),
        (context) => SizeHelper.of(context).helpBuilder(
          mobileSmall: (info) => info,
        ),
      );
      expect(info.orientation, Orientation.portrait);
    },
    variant: TargetPlatformVariant.all(),
  );

  testWidgets('web uses the width for the breakpoint', (tester) async {
    Future<String> at(double width) => resolveAt(
          tester,
          Size(width, 300),
          (context) =>
              helpWithAll(SizeHelper.of(context), omit: landscapeNames),
        );

    expect(await at(387.5), 'mobileExtraLarge');
    expect(await at(388), 'tabletSmall');
    expect(await at(1050), 'desktopSmall');
    expect(await at(1050.5), 'desktopNormal');
  });
}
