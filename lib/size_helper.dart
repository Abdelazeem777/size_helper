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
  double _current;
  Size _size;
  Orientation _orientation;
  bool _printScreenInfo;

  static SizeHelper of(BuildContext context, {bool printScreenInfo = false}) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final orientation =
        width > height ? Orientation.landscape : Orientation.portrait;

    final current = orientation == Orientation.portrait ? height : width;

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
    final isPortrait = _orientation == Orientation.portrait;

    if (_printScreenInfo) _printCurrentScreenInfo(_current, _size, isPortrait);

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
      if (mobileSmallLandscape != null)
        Node(_BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormalLandscape != null)
        Node(_BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLargeLandscape != null)
        Node(_BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLargeLandscape != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmallLandscape != null)
        Node(_BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormalLandscape != null)
        Node(_BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLargeLandscape != null)
        Node(_BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLargeLandscape != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmallLandscape != null)
        Node(_BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormalLandscape != null)
        Node(_BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLargeLandscape != null)
        Node(_BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLargeLandscape != null)
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
    final isPortrait = _orientation == Orientation.portrait;

    if (_printScreenInfo) _printCurrentScreenInfo(_current, _size, isPortrait);

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
      if (mobileSmallLandscape != null)
        Node(_BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormalLandscape != null)
        Node(_BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLargeLandscape != null)
        Node(_BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLargeLandscape != null)
        Node(_BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmallLandscape != null)
        Node(_BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormalLandscape != null)
        Node(_BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLargeLandscape != null)
        Node(_BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLargeLandscape != null)
        Node(_BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmallLandscape != null)
        Node(_BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormalLandscape != null)
        Node(_BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLargeLandscape != null)
        Node(_BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLargeLandscape != null)
        Node(_BreakPoint.desktopExtraLarge, desktopExtraLargeLandscape),
    ];

    final closestNode = _findClosestNode(
      _current,
      isPortrait,
      portraitNodesList,
      landscapeNodesList,
    );

    if (closestNode != null)
      return closestNode.value(_size.width, _size.height);
    else
      throw Exception(
          'Screen size not specified or there is no options passed from the parameters [current: `$_current`, orientation: `$_orientation`]');
  }

  Node<T>? _findClosestNode<T>(double currentSize, bool isPortrait,
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

  Node<T>? _findClosestNodeFromList<T>(
      List<Node<T>> nodesList, double current) {
    if (nodesList.isEmpty) return null;
    var closestNode = nodesList.first;
    var minDifference = (closestNode.breakPoint - current).abs();
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

  void _printCurrentScreenInfo(double current, Size size, bool isPortrait) {
    final orientationText = isPortrait ? 'Portrait' : 'Landscape';
    final f = _differenceBetweenCurrentAndBreakPoint;
    final screenInfoNodes = [
      Node(
        _BreakPoint.mobileSmall,
        'SizeHelper: ${f(current, _BreakPoint.mobileSmall)} mobileSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.mobileNormal,
        'SizeHelper: ${f(current, _BreakPoint.mobileNormal)} mobileNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.mobileLarge,
        'SizeHelper: ${f(current, _BreakPoint.mobileLarge)} mobileLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.mobileExtraLarge,
        'SizeHelper: ${f(current, _BreakPoint.mobileExtraLarge)} mobileExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.tabletSmall,
        'SizeHelper: ${f(current, _BreakPoint.tabletSmall)} tabletSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.tabletNormal,
        'SizeHelper: ${f(current, _BreakPoint.tabletNormal)} tabletNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.tabletLarge,
        'SizeHelper: ${f(current, _BreakPoint.tabletLarge)} tabletLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.tabletExtraLarge,
        'SizeHelper: ${f(current, _BreakPoint.tabletExtraLarge)} tabletExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.desktopSmall,
        'SizeHelper: ${f(current, _BreakPoint.desktopSmall)} desktopSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.desktopNormal,
        'SizeHelper: ${f(current, _BreakPoint.desktopNormal)} desktopNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.desktopLarge,
        'SizeHelper: ${f(current, _BreakPoint.desktopLarge)} desktopLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        _BreakPoint.desktopExtraLarge,
        'SizeHelper: ${f(current, _BreakPoint.desktopExtraLarge)} desktopExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
    ];

    final closestNode = _findClosestNodeFromList(screenInfoNodes, current);
    print(closestNode!.value);
  }

  String _differenceBetweenCurrentAndBreakPoint(
      double current, double breakPoint) {
    if (current > breakPoint)
      return '+';
    else if (current == breakPoint)
      return '=';
    else
      return '-';
  }
}

class _BreakPoint {
  static const mobileSmall = 320.0;
  static const mobileNormal = 375.0;
  static const mobileLarge = 414.0;
  static const mobileExtraLarge = 480.0;
  static const tabletSmall = 600.0;
  static const tabletNormal = 768.0;
  static const tabletLarge = 840.0;
  static const tabletExtraLarge = 1080.0;
  static const desktopSmall = 1280.0;
  static const desktopNormal = 1775.0;
  static const desktopLarge = 3540.0;
  static const desktopExtraLarge = 4096.0;
}

class Node<T> {
  final double breakPoint;
  final T value;

  const Node(this.breakPoint, this.value);
}
