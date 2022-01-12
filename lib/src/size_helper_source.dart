import 'dart:developer' show log;

import 'breakpoints.dart';
import 'package:flutter/widgets.dart'
    show Size, Orientation, BuildContext, MediaQuery;

import 'node.dart';

/// Takes  `T Function(double width, double height, Orientation orientation)` as a parameter
typedef HelpBuilderCallback<T> = T Function(
    double width, double height, Orientation orientation);

class SizeHelper {
  SizeHelper._internal(
    this._currentLength,
    this._size,
    this._currentOrientation,
    this._printScreenInfo,
  );
  double _currentLength;
  Size _size;
  Orientation _currentOrientation;
  bool _printScreenInfo;

  static double? _oldLength;
  static Orientation? _oldOrientation;
  static double? _cachedBreakPoint;

  static SizeHelper of(BuildContext context, {bool printScreenInfo = false}) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final currentOrientation =
        width > height ? Orientation.landscape : Orientation.portrait;

    final currentLength =
        currentOrientation == Orientation.portrait ? height : width;

    return SizeHelper._internal(
      currentLength,
      size,
      currentOrientation,
      printScreenInfo,
    );
  }

  T help<T>({
    T? mobileSmall,
    T? mobileSmallLandscape,
    T? mobileNormal,
    T? mobileNormalLandscape,
    T? mobileLarge,
    T? mobileLargeLandscape,
    T? mobileExtraLarge,
    T? mobileExtraLargeLandscape,
    T? tabletSmall,
    T? tabletSmallLandscape,
    T? tabletNormal,
    T? tabletNormalLandscape,
    T? tabletLarge,
    T? tabletLargeLandscape,
    T? tabletExtraLarge,
    T? tabletExtraLargeLandscape,
    T? desktopSmall,
    T? desktopSmallLandscape,
    T? desktopNormal,
    T? desktopNormalLandscape,
    T? desktopLarge,
    T? desktopLargeLandscape,
    T? desktopExtraLarge,
    T? desktopExtraLargeLandscape,
  }) {
    final isPortrait = _currentOrientation == Orientation.portrait;

    if (_printScreenInfo)
      _printCurrentScreenInfo(_currentLength, _size, isPortrait);

    final portraitMap = {
      if (mobileSmall != null) BreakPoint.mobileSmall: mobileSmall,
      if (mobileNormal != null) BreakPoint.mobileNormal: mobileNormal,
      if (mobileLarge != null) BreakPoint.mobileLarge: mobileLarge,
      if (mobileExtraLarge != null)
        BreakPoint.mobileExtraLarge: mobileExtraLarge,
      if (tabletSmall != null) BreakPoint.tabletSmall: tabletSmall,
      if (tabletNormal != null) BreakPoint.tabletNormal: tabletNormal,
      if (tabletLarge != null) BreakPoint.tabletLarge: tabletLarge,
      if (tabletExtraLarge != null)
        BreakPoint.tabletExtraLarge: tabletExtraLarge,
      if (desktopSmall != null) BreakPoint.desktopSmall: desktopSmall,
      if (desktopNormal != null) BreakPoint.desktopNormal: desktopNormal,
      if (desktopLarge != null) BreakPoint.desktopLarge: desktopLarge,
      if (desktopExtraLarge != null)
        BreakPoint.desktopExtraLarge: desktopExtraLarge,
    };

    final landscapeMap = {
      if (mobileSmallLandscape != null)
        BreakPoint.mobileSmall: mobileSmallLandscape,
      if (mobileNormalLandscape != null)
        BreakPoint.mobileNormal: mobileNormalLandscape,
      if (mobileLargeLandscape != null)
        BreakPoint.mobileLarge: mobileLargeLandscape,
      if (mobileExtraLargeLandscape != null)
        BreakPoint.mobileExtraLarge: mobileExtraLargeLandscape,
      if (tabletSmallLandscape != null)
        BreakPoint.tabletSmall: tabletSmallLandscape,
      if (tabletNormalLandscape != null)
        BreakPoint.tabletNormal: tabletNormalLandscape,
      if (tabletLargeLandscape != null)
        BreakPoint.tabletLarge: tabletLargeLandscape,
      if (tabletExtraLargeLandscape != null)
        BreakPoint.tabletExtraLarge: tabletExtraLargeLandscape,
      if (desktopSmallLandscape != null)
        BreakPoint.desktopSmall: desktopSmallLandscape,
      if (desktopNormalLandscape != null)
        BreakPoint.desktopNormal: desktopNormalLandscape,
      if (desktopLargeLandscape != null)
        BreakPoint.desktopLarge: desktopLargeLandscape,
      if (desktopExtraLargeLandscape != null)
        BreakPoint.desktopExtraLarge: desktopExtraLargeLandscape,
    };

    final closestMapEntry = _findClosestMapEntry(
      _currentLength,
      isPortrait,
      portraitMap,
      landscapeMap,
    );

    if (closestMapEntry != null) {
      _oldLength = _currentLength;
      _oldOrientation = _currentOrientation;
      _cachedBreakPoint = closestMapEntry.key;
      return closestMapEntry.value!;
    } else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [currentLength: `$_currentLength`, orientation: `$_currentOrientation`]');
  }

  /// Takes  `T Function(double width, double height)` as a parameter
  T helpBuilder<T>({
    HelpBuilderCallback<T>? mobileSmall,
    HelpBuilderCallback<T>? mobileSmallLandscape,
    HelpBuilderCallback<T>? mobileNormal,
    HelpBuilderCallback<T>? mobileNormalLandscape,
    HelpBuilderCallback<T>? mobileLarge,
    HelpBuilderCallback<T>? mobileLargeLandscape,
    HelpBuilderCallback<T>? mobileExtraLarge,
    HelpBuilderCallback<T>? mobileExtraLargeLandscape,
    HelpBuilderCallback<T>? tabletSmall,
    HelpBuilderCallback<T>? tabletSmallLandscape,
    HelpBuilderCallback<T>? tabletNormal,
    HelpBuilderCallback<T>? tabletNormalLandscape,
    HelpBuilderCallback<T>? tabletLarge,
    HelpBuilderCallback<T>? tabletLargeLandscape,
    HelpBuilderCallback<T>? tabletExtraLarge,
    HelpBuilderCallback<T>? tabletExtraLargeLandscape,
    HelpBuilderCallback<T>? desktopSmall,
    HelpBuilderCallback<T>? desktopSmallLandscape,
    HelpBuilderCallback<T>? desktopNormal,
    HelpBuilderCallback<T>? desktopNormalLandscape,
    HelpBuilderCallback<T>? desktopLarge,
    HelpBuilderCallback<T>? desktopLargeLandscape,
    HelpBuilderCallback<T>? desktopExtraLarge,
    HelpBuilderCallback<T>? desktopExtraLargeLandscape,
  }) {
    final isPortrait = _currentOrientation == Orientation.portrait;

    if (_printScreenInfo)
      _printCurrentScreenInfo(_currentLength, _size, isPortrait);

    final portraitMap = {
      if (mobileSmall != null) BreakPoint.mobileSmall: mobileSmall,
      if (mobileNormal != null) BreakPoint.mobileNormal: mobileNormal,
      if (mobileLarge != null) BreakPoint.mobileLarge: mobileLarge,
      if (mobileExtraLarge != null)
        BreakPoint.mobileExtraLarge: mobileExtraLarge,
      if (tabletSmall != null) BreakPoint.tabletSmall: tabletSmall,
      if (tabletNormal != null) BreakPoint.tabletNormal: tabletNormal,
      if (tabletLarge != null) BreakPoint.tabletLarge: tabletLarge,
      if (tabletExtraLarge != null)
        BreakPoint.tabletExtraLarge: tabletExtraLarge,
      if (desktopSmall != null) BreakPoint.desktopSmall: desktopSmall,
      if (desktopNormal != null) BreakPoint.desktopNormal: desktopNormal,
      if (desktopLarge != null) BreakPoint.desktopLarge: desktopLarge,
      if (desktopExtraLarge != null)
        BreakPoint.desktopExtraLarge: desktopExtraLarge,
    };

    final landscapeMap = {
      if (mobileSmallLandscape != null)
        BreakPoint.mobileSmall: mobileSmallLandscape,
      if (mobileNormalLandscape != null)
        BreakPoint.mobileNormal: mobileNormalLandscape,
      if (mobileLargeLandscape != null)
        BreakPoint.mobileLarge: mobileLargeLandscape,
      if (mobileExtraLargeLandscape != null)
        BreakPoint.mobileExtraLarge: mobileExtraLargeLandscape,
      if (tabletSmallLandscape != null)
        BreakPoint.tabletSmall: tabletSmallLandscape,
      if (tabletNormalLandscape != null)
        BreakPoint.tabletNormal: tabletNormalLandscape,
      if (tabletLargeLandscape != null)
        BreakPoint.tabletLarge: tabletLargeLandscape,
      if (tabletExtraLargeLandscape != null)
        BreakPoint.tabletExtraLarge: tabletExtraLargeLandscape,
      if (desktopSmallLandscape != null)
        BreakPoint.desktopSmall: desktopSmallLandscape,
      if (desktopNormalLandscape != null)
        BreakPoint.desktopNormal: desktopNormalLandscape,
      if (desktopLargeLandscape != null)
        BreakPoint.desktopLarge: desktopLargeLandscape,
      if (desktopExtraLargeLandscape != null)
        BreakPoint.desktopExtraLarge: desktopExtraLargeLandscape,
    };

    final closestMapEntry = _findClosestMapEntry(
      _currentLength,
      isPortrait,
      portraitMap,
      landscapeMap,
    );

    if (closestMapEntry != null) {
      _oldLength = _currentLength;
      _oldOrientation = _currentOrientation;
      _cachedBreakPoint = closestMapEntry.key;
      return closestMapEntry.value(
          _size.width, _size.height, _currentOrientation);
    } else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [currentLength: `$_currentLength`, orientation: `$_currentOrientation`]');
  }

  MapEntry<double, T>? _findClosestMapEntry<T>(
    double currentLengthSize,
    bool isPortrait,
    Map<double, T> portraitMap,
    Map<double, T> landscapeMap,
  ) {
    // FIXME: the problem here is that the _cachedBreakPoint may not be the closest one,
    // it's just the closest for the last search,
    // so we need to find a better way to cache it.
    if (_oldLength == _currentLength &&
        _oldOrientation == _currentOrientation) {
      final value = isPortrait
          ? portraitMap[_cachedBreakPoint]
          : landscapeMap[_cachedBreakPoint];
      if (value != null) return MapEntry(_cachedBreakPoint!, value);
    }

    var closestMapEntry = isPortrait
        ? _findClosestMapEntryFromMap(portraitMap, currentLengthSize)
        : _findClosestMapEntryFromMap(landscapeMap, currentLengthSize);

    if (closestMapEntry == null)
      closestMapEntry = !isPortrait
          ? _findClosestMapEntryFromMap(portraitMap, currentLengthSize)
          : _findClosestMapEntryFromMap(landscapeMap, currentLengthSize);

    return closestMapEntry;
  }

  MapEntry<double, T>? _findClosestMapEntryFromMap<T>(
    Map<double, T> map,
    double currentLength,
  ) {
    if (map.isEmpty) return null;
    var closestMapEntry = map.entries.first;
    var minDifference = (closestMapEntry.key - currentLength).abs();
    map.forEach((key, value) {
      final difference = (key - currentLength).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestMapEntry = MapEntry(key, value);
      }
    });
    return closestMapEntry;
  }

  void _printCurrentScreenInfo(
      double currentLength, Size size, bool isPortrait) {
    final orientationText = isPortrait ? 'Portrait' : 'Landscape';
    final f = _differenceBetweenCurrentAndBreakPoint;
    final screenInfoMapEntrys = {
      BreakPoint.mobileSmall:
          'SizeHelper: ${f(currentLength, BreakPoint.mobileSmall)} mobileSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.mobileNormal:
          'SizeHelper: ${f(currentLength, BreakPoint.mobileNormal)} mobileNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.mobileLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.mobileLarge)} mobileLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.mobileExtraLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.mobileExtraLarge)} mobileExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.tabletSmall:
          'SizeHelper: ${f(currentLength, BreakPoint.tabletSmall)} tabletSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.tabletNormal:
          'SizeHelper: ${f(currentLength, BreakPoint.tabletNormal)} tabletNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.tabletLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.tabletLarge)} tabletLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.tabletExtraLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.tabletExtraLarge)} tabletExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.desktopSmall:
          'SizeHelper: ${f(currentLength, BreakPoint.desktopSmall)} desktopSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.desktopNormal:
          'SizeHelper: ${f(currentLength, BreakPoint.desktopNormal)} desktopNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.desktopLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.desktopLarge)} desktopLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      BreakPoint.desktopExtraLarge:
          'SizeHelper: ${f(currentLength, BreakPoint.desktopExtraLarge)} desktopExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
    };

    final closestMapEntry =
        _findClosestMapEntryFromMap(screenInfoMapEntrys, currentLength);
    log(closestMapEntry!.value);
  }

  String _differenceBetweenCurrentAndBreakPoint(
      double currentLength, double breakPoint) {
    if (currentLength > breakPoint)
      return '+';
    else if (currentLength == breakPoint)
      return '=';
    else
      return '-';
  }
}
