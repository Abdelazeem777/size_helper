import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show BuildContext, Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:size_helper/size_helper.dart';

import 'size_helper_test.mocks.dart';

main() {
  group('[help] method', () {
    test('Returns mobileSmall choice', () {
      final context = _createContextWithSize(150.0, 300.0);
      final result = SizeHelper.of(context, printScreenInfo: true).help(
        mobileSmall: 'right',
        mobileNormal: 'wrong',
        tabletExtraLarge: 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileNormal choice if mobileSmall not specified', () {
      final context = _createContextWithSize(150.0, 300.0);
      final result = SizeHelper.of(context).help(
        mobileNormal: 'right',
        tabletExtraLarge: 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileSmall choice  (landscape)', () {
      final context = _createContextWithSize(300.0, 150.0);
      final result = SizeHelper.of(context, printScreenInfo: true).help(
        mobileSmall: 'wrong',
        mobileSmallLandscape: 'right',
        mobileNormal: 'wrong',
        tabletExtraLarge: 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns desktopSmall choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context).help(
        mobileSmall: 'wrong',
        mobileNormal: 'wrong',
        tabletExtraLarge: 'wrong',
        desktopSmall: 'right',
        desktopLarge: 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns tableExtraLarge if desktopSmall not exist choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context, printScreenInfo: true).help(
        mobileSmall: 'wrong',
        mobileNormal: 'wrong',
        tabletExtraLarge: 'right',
      );

      expect(result, 'right');
    });
  });

  group('[helpBuilder] method', () {
    test('Returns mobileSmall choice', () {
      final context = _createContextWithSize(150.0, 300.0);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __) => 'right',
        mobileNormal: (_, __) => 'wrong',
        tabletExtraLarge: (_, __) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileNormal choice if mobileSmall not specified', () {
      final context = _createContextWithSize(150.0, 300.0);
      final result = SizeHelper.of(context).helpBuilder(
        mobileNormal: (_, __) => 'right',
        tabletExtraLarge: (_, __) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileSmall choice  (landscape)', () {
      final context = _createContextWithSize(300.0, 150.0);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __) => 'wrong',
        mobileSmallLandscape: (_, __) => 'right',
        mobileNormal: (_, __) => 'wrong',
        tabletExtraLarge: (_, __) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns desktopSmall choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context).helpBuilder(
        mobileSmall: (_, __) => 'wrong',
        mobileNormal: (_, __) => 'wrong',
        tabletExtraLarge: (_, __) => 'wrong',
        desktopSmall: (_, __) => 'right',
        desktopLarge: (_, __) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns tableExtraLarge if desktopSmall not exist choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __) => 'wrong',
        mobileNormal: (_, __) => 'wrong',
        tabletExtraLarge: (_, __) => 'right',
      );

      expect(result, 'right');
    });

    test('Returns tableExtraLarge if desktopSmall not exist choice (landscape)',
        () {
      final context = _createContextWithSize(1044.0, 763.2000122070312);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __) => 'wrong',
        mobileNormal: (_, __) => 'wrong',
        tabletExtraLarge: (_, __) => 'right',
      );

      expect(result, 'right');
    });
  });
}

@GenerateMocks([BuildContext])
BuildContext _createContextWithSize(double width, double height) {
  final context = MockBuildContext();
  final mediaQuery = MediaQuery(
    data: MediaQueryData(size: Size(width, height)),
    child: const SizedBox(),
  );
  when(context.widget).thenReturn(const SizedBox());
  when(context.findAncestorWidgetOfExactType()).thenReturn(mediaQuery);
  when(context.dependOnInheritedWidgetOfExactType<MediaQuery>())
      .thenReturn(mediaQuery);
  return context;
}
