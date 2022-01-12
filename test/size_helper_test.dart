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
        mobileSmall: (_, __, ___) => 'right',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, ___) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileNormal choice if mobileSmall not specified', () {
      final context = _createContextWithSize(150.0, 300.0);
      final result = SizeHelper.of(context).helpBuilder(
        mobileNormal: (_, __, ___) => 'right',
        tabletExtraLarge: (_, __, ___) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns mobileSmall choice  (landscape)', () {
      final context = _createContextWithSize(300.0, 150.0);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __, ___) => 'wrong',
        mobileSmallLandscape: (_, __, ___) => 'right',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, ___) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns desktopSmall choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context).helpBuilder(
        mobileSmall: (_, __, ___) => 'wrong',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, ___) => 'wrong',
        desktopSmall: (_, __, ___) => 'right',
        desktopLarge: (_, __, ___) => 'wrong',
      );

      expect(result, 'right');
    });
    test('Returns tableExtraLarge if desktopSmall not exist choice', () {
      final context = _createContextWithSize(150.0, 1900.0);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __, ___) => 'wrong',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, ___) => 'right',
      );

      expect(result, 'right');
    });

    test('Returns tableExtraLarge if desktopSmall not exist choice (landscape)',
        () {
      final context = _createContextWithSize(1044.0, 763.2000122070312);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __, ___) => 'wrong',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, ___) => 'right',
      );

      expect(result, 'right');
    });
    test('Landscape option', () {
      final context = _createContextWithSize(1044.0, 763.2000122070312);
      final result = SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileSmall: (_, __, ___) => 'wrong',
        mobileNormal: (_, __, ___) => 'wrong',
        tabletExtraLarge: (_, __, orientation) =>
            orientation == Orientation.landscape ? 'right' : 'wrong',
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
  when(context.getElementForInheritedWidgetOfExactType())
      .thenReturn(InheritedElement(mediaQuery));
  return context;
}
