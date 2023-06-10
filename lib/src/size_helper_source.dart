import 'dart:developer' show log;

import 'package:size_helper/src/screen_info.dart';

import 'breakpoints.dart';
import 'package:flutter/widgets.dart'
    show Size, Orientation, BuildContext, MediaQuery;

/// Takes `T Function(double width, double height, Orientation orientation)` as a parameter
typedef HelpBuilderCallback<T> = T Function(ScreenInfo screenInfo);

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
  static List<BreakPoint>? _cachedBreakPointsList;

  static SizeHelper of(BuildContext context, {bool printScreenInfo = false}) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final currentOrientation =
        width > height ? Orientation.landscape : Orientation.portrait;

    final currentLength =
        currentOrientation == Orientation.portrait ? width : height;

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
    final closestBreakPoints =
        _oldLength == _currentLength && _oldOrientation == _currentOrientation
            ? _cachedBreakPointsList!
            : _getSortedBreakPointsByClosestTo(_currentLength);

    _oldLength = _currentLength;
    _oldOrientation = _currentOrientation;
    _cachedBreakPointsList = closestBreakPoints;

    if (_printScreenInfo)
      _printCurrentScreenInfo(
        currentLength: _currentLength,
        closestBreakPoint: closestBreakPoints.first,
        size: _size,
        isPortrait: isPortrait,
      );

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

    final closestItem = _findClosest(
      closestBreakPoints,
      isPortrait,
      portraitMap,
      landscapeMap,
    );

    if (closestItem != null)
      return closestItem;
    else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [currentLength: `$_currentLength`, orientation: `$_currentOrientation`]');
  }

  /// Takes `T Function(double width, double height)` as a parameter
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

    final closestBreakPoints =
        _oldLength == _currentLength && _oldOrientation == _currentOrientation
            ? _cachedBreakPointsList!
            : _getSortedBreakPointsByClosestTo(_currentLength);

    _oldLength = _currentLength;
    _oldOrientation = _currentOrientation;
    _cachedBreakPointsList = closestBreakPoints;

    if (_printScreenInfo)
      _printCurrentScreenInfo(
        currentLength: _currentLength,
        closestBreakPoint: closestBreakPoints.first,
        size: _size,
        isPortrait: isPortrait,
      );

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

    final closest = _findClosest(
      closestBreakPoints,
      isPortrait,
      portraitMap,
      landscapeMap,
    );

    if (closest != null) {
      return closest(
        ScreenInfo(
          width: _size.width,
          height: _size.height,
          orientation: _currentOrientation,
        ),
      );
    } else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [currentLength: `$_currentLength`, orientation: `$_currentOrientation`]');
  }

  T? _findClosest<T>(
    List<BreakPoint> closestBreakPoints,
    bool isPortrait,
    Map<BreakPoint, T> portraitMap,
    Map<BreakPoint, T> landscapeMap,
  ) {
    var closest = isPortrait
        ? _findClosestFromMap(portraitMap, closestBreakPoints)
        : _findClosestFromMap(landscapeMap, closestBreakPoints);

    if (closest == null)
      closest = !isPortrait
          ? _findClosestFromMap(portraitMap, closestBreakPoints)
          : _findClosestFromMap(landscapeMap, closestBreakPoints);

    return closest;
  }

  T? _findClosestFromMap<T>(
    Map<BreakPoint, T> map,
    List<BreakPoint> closestBreakPoints,
  ) {
    if (map.isEmpty) return null;
    for (var breakPoint in closestBreakPoints) {
      final closest = map[breakPoint];
      if (closest != null) return closest;
    }
  }

  List<BreakPoint> _getSortedBreakPointsByClosestTo(double currentLength) {
    final sortedList = BreakPoint.values;
    sortedList.sort(
      (a, b) => (a.value - currentLength)
          .abs()
          .compareTo((b.value - currentLength).abs()),
    );
    return sortedList;
  }

  void _printCurrentScreenInfo({
    required double currentLength,
    required BreakPoint closestBreakPoint,
    required Size size,
    required bool isPortrait,
  }) {
    final orientationText = isPortrait ? 'Portrait' : 'Landscape';
    final difference = _differenceBetweenCurrentAndBreakPoint(
        currentLength, closestBreakPoint.value);
    log('SizeHelper: $difference ${closestBreakPoint.name} | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText');
  }

  String _differenceBetweenCurrentAndBreakPoint(
      double currentLength, double breakPointValue) {
    if (currentLength > breakPointValue)
      return '+';
    else if (currentLength == breakPointValue)
      return '=';
    else
      return '-';
  }
}
