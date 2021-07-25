library size_helper;

import 'package:flutter/widgets.dart'
    show Size, Orientation, BuildContext, MediaQuery;

class SizeHelper {
  SizeHelper._internal(
    this._current,
    this._size,
    this._orientation,
    this._printScreenInfo,
  );
  int _current;
  Size _size;
  Orientation _orientation;
  bool _printScreenInfo;

  static SizeHelper of(BuildContext context, {bool printScreenInfo = false}) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final orientation =
        width > height ? Orientation.landscape : Orientation.portrait;

    final current =
        (orientation == Orientation.portrait ? height : width).toInt();

    return SizeHelper._internal(current, size, orientation, printScreenInfo);
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
    if (_printScreenInfo) _printCurrentScreenInfo(_current);

    final isPortrait = _orientation == Orientation.portrait;

    final portraitNodesList = [
      if (mobileSmall != null) Node(_BreakPoint.mobileSmall, mobileSmall),
      if (mobileNormal != null) Node(_BreakPoint.mobileNormal, mobileNormal),
      if (mobileLarge != null) Node(_BreakPoint.mobileLarge, mobileLarge),
      if (mobileExtraLarge != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLarge),
      if (tabletSmall != null) Node(_BreakPoint.tabletSmall, tabletSmall),
      if (tabletNormal != null) Node(_BreakPoint.tabletNormal, tabletNormal),
      if (tabletLarge != null) Node(_BreakPoint.tabletLarge, tabletLarge),
      if (tabletExtraLarge != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLarge),
      if (desktopSmall != null) Node(_BreakPoint.desktopSmall, desktopSmall),
      if (desktopNormal != null) Node(_BreakPoint.desktopNormal, desktopNormal),
      if (desktopLarge != null) Node(_BreakPoint.desktopLarge, desktopLarge),
      if (desktopExtraLarge != null)
        Node(_BreakPoint.desktopExtraLarge, desktopExtraLarge),
    ];

    final landscapeNodesList = [
      if (mobileSmall != null)
        Node(_BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormal != null)
        Node(_BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLarge != null)
        Node(_BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLarge != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmall != null)
        Node(_BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormal != null)
        Node(_BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLarge != null)
        Node(_BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLarge != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmall != null)
        Node(_BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormal != null)
        Node(_BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLarge != null)
        Node(_BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLarge != null)
        Node(_BreakPoint.desktopExtraLarge, desktopExtraLargeLandscape),
    ];

    final closestNode = _findClosestNode(
      _current,
      isPortrait,
      portraitNodesList,
      landscapeNodesList,
    );

    if (closestNode != null)
      return closestNode.value!;
    else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [current: `$_current`, orientation: `$_orientation`]');
  }

  /// Takes  `T Function(double width, double height)` as a parameter
  T helpBuilder<T>({
    T Function(double width, double height)? mobileSmall,
    T Function(double width, double height)? mobileSmallLandscape,
    T Function(double width, double height)? mobileNormal,
    T Function(double width, double height)? mobileNormalLandscape,
    T Function(double width, double height)? mobileLarge,
    T Function(double width, double height)? mobileLargeLandscape,
    T Function(double width, double height)? mobileExtraLarge,
    T Function(double width, double height)? mobileExtraLargeLandscape,
    T Function(double width, double height)? tabletSmall,
    T Function(double width, double height)? tabletSmallLandscape,
    T Function(double width, double height)? tabletNormal,
    T Function(double width, double height)? tabletNormalLandscape,
    T Function(double width, double height)? tabletLarge,
    T Function(double width, double height)? tabletLargeLandscape,
    T Function(double width, double height)? tabletExtraLarge,
    T Function(double width, double height)? tabletExtraLargeLandscape,
    T Function(double width, double height)? desktopSmall,
    T Function(double width, double height)? desktopSmallLandscape,
    T Function(double width, double height)? desktopNormal,
    T Function(double width, double height)? desktopNormalLandscape,
    T Function(double width, double height)? desktopLarge,
    T Function(double width, double height)? desktopLargeLandscape,
    T Function(double width, double height)? desktopExtraLarge,
    T Function(double width, double height)? desktopExtraLargeLandscape,
  }) {
    if (_printScreenInfo) _printCurrentScreenInfo(_current);

    final isPortrait = _orientation == Orientation.portrait;

    final portraitNodesList = [
      if (mobileSmall != null) Node(_BreakPoint.mobileSmall, mobileSmall),
      if (mobileNormal != null) Node(_BreakPoint.mobileNormal, mobileNormal),
      if (mobileLarge != null) Node(_BreakPoint.mobileLarge, mobileLarge),
      if (mobileExtraLarge != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLarge),
      if (tabletSmall != null) Node(_BreakPoint.tabletSmall, tabletSmall),
      if (tabletNormal != null) Node(_BreakPoint.tabletNormal, tabletNormal),
      if (tabletLarge != null) Node(_BreakPoint.tabletLarge, tabletLarge),
      if (tabletExtraLarge != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLarge),
      if (desktopSmall != null) Node(_BreakPoint.desktopSmall, desktopSmall),
      if (desktopNormal != null) Node(_BreakPoint.desktopNormal, desktopNormal),
      if (desktopLarge != null) Node(_BreakPoint.desktopLarge, desktopLarge),
      if (desktopExtraLarge != null)
        Node(_BreakPoint.desktopExtraLarge, desktopExtraLarge),
    ];

    final landscapeNodesList = [
      if (mobileSmall != null)
        Node(_BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormal != null)
        Node(_BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLarge != null)
        Node(_BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLarge != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmall != null)
        Node(_BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormal != null)
        Node(_BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLarge != null)
        Node(_BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLarge != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmall != null)
        Node(_BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormal != null)
        Node(_BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLarge != null)
        Node(_BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLarge != null)
        Node(_BreakPoint.desktopExtraLarge, desktopExtraLargeLandscape),
    ];

    final closestNode = _findClosestNode(
      _current,
      isPortrait,
      portraitNodesList,
      landscapeNodesList,
    );

    if (closestNode != null)
      return closestNode.value!(_size.width, _size.height);
    else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [current: `$_current`, orientation: `$_orientation`]');
  }

  Node<T>? _findClosestNode<T>(int currentSize, bool isPortrait,
      List<Node<T>> portraitNodesList, List<Node<T>> landscapeNodesList) {
    var closestNode = isPortrait
        ? _findClosestNodeFromList(portraitNodesList, currentSize)
        : _findClosestNodeFromList(landscapeNodesList, currentSize);

    if (closestNode == null)
      closestNode = !isPortrait
          ? _findClosestNodeFromList(portraitNodesList, currentSize)
          : _findClosestNodeFromList(landscapeNodesList, currentSize);
    return closestNode;
  }

  Node<T>? _findClosestNodeFromList<T>(List<Node<T>> nodesList, int current) {
    if (nodesList.isEmpty) return null;
    var closestNode = nodesList.first;
    int minDifference = (closestNode.breakPoint - current).abs();
    for (int i = 1; i < nodesList.length; i++) {
      final node = nodesList[i];
      final difference = (node.breakPoint - current).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNode = node;
      }
    }
    return closestNode;
  }

  void _printCurrentScreenInfo(int current) {
    if (current < _BreakPoint.mobileNormal)
      return print(
          'SizeHelper: mobileSmall | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.mobileLarge)
      return print(
          'SizeHelper: mobileNormal | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.mobileExtraLarge)
      return print(
          'SizeHelper: mobileLarge | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.tabletSmall)
      return print(
          'SizeHelper: mobileExtraLarge | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.tabletNormal)
      return print(
          'SizeHelper: tabletSmall | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.tabletLarge)
      return print(
          'SizeHelper: tabletNormal | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.tabletExtraLarge)
      return print(
          'SizeHelper: tabletLarge | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.desktopSmall)
      return print(
          'SizeHelper: tabletExtraLarge | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.desktopNormal)
      return print(
          'SizeHelper: desktopSmall | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.desktopLarge)
      return print(
          'SizeHelper: desktopNormal | Width: ${_size.width} | Height: ${_size.height}');
    if (current < _BreakPoint.desktopExtraLarge)
      return print(
          'SizeHelper: desktopLarge | Width: ${_size.width} | Height: ${_size.height}');
    else
      return print(
          'SizeHelper: desktopExtraLarge | Width: ${_size.width} | Height: ${_size.height}');
  }
}

class _BreakPoint {
  static const mobileSmall = 320;
  static const mobileNormal = 375;
  static const mobileLarge = 414;
  static const mobileExtraLarge = 480;
  static const tabletSmall = 600;
  static const tabletNormal = 768;
  static const tabletLarge = 850;
  static const tabletExtraLarge = 900;
  static const desktopSmall = 950;
  static const desktopNormal = 1920;
  static const desktopLarge = 3840;
  static const desktopExtraLarge = 4096;
}

class Node<T> {
  final int breakPoint;
  final T value;

  Node(this.breakPoint, this.value);
}
