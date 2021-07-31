import 'breakpoints.dart';
import 'package:flutter/widgets.dart'
    show Size, Orientation, BuildContext, MediaQuery;

import 'node.dart';

/// Takes  `T Function(double width, double height)` as a parameter
typedef HelpBuilderCallback<T> = T Function(double width, double height);

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
      if (mobileSmall != null) Node(BreakPoint.mobileSmall, mobileSmall),
      if (mobileNormal != null) Node(BreakPoint.mobileNormal, mobileNormal),
      if (mobileLarge != null) Node(BreakPoint.mobileLarge, mobileLarge),
      if (mobileExtraLarge != null)
        Node(BreakPoint.mobileExtraLarge, mobileExtraLarge),
      if (tabletSmall != null) Node(BreakPoint.tabletSmall, tabletSmall),
      if (tabletNormal != null) Node(BreakPoint.tabletNormal, tabletNormal),
      if (tabletLarge != null) Node(BreakPoint.tabletLarge, tabletLarge),
      if (tabletExtraLarge != null)
        Node(BreakPoint.tabletExtraLarge, tabletExtraLarge),
      if (desktopSmall != null) Node(BreakPoint.desktopSmall, desktopSmall),
      if (desktopNormal != null) Node(BreakPoint.desktopNormal, desktopNormal),
      if (desktopLarge != null) Node(BreakPoint.desktopLarge, desktopLarge),
      if (desktopExtraLarge != null)
        Node(BreakPoint.desktopExtraLarge, desktopExtraLarge),
    ];

    final landscapeNodesList = [
      if (mobileSmallLandscape != null)
        Node(BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormalLandscape != null)
        Node(BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLargeLandscape != null)
        Node(BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLargeLandscape != null)
        Node(BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmallLandscape != null)
        Node(BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormalLandscape != null)
        Node(BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLargeLandscape != null)
        Node(BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLargeLandscape != null)
        Node(BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmallLandscape != null)
        Node(BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormalLandscape != null)
        Node(BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLargeLandscape != null)
        Node(BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLargeLandscape != null)
        Node(BreakPoint.desktopExtraLarge, desktopExtraLargeLandscape),
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
    final isPortrait = _orientation == Orientation.portrait;

    if (_printScreenInfo) _printCurrentScreenInfo(_current, _size, isPortrait);

    final portraitNodesList = [
      if (mobileSmall != null) Node(BreakPoint.mobileSmall, mobileSmall),
      if (mobileNormal != null) Node(BreakPoint.mobileNormal, mobileNormal),
      if (mobileLarge != null) Node(BreakPoint.mobileLarge, mobileLarge),
      if (mobileExtraLarge != null)
        Node(BreakPoint.mobileExtraLarge, mobileExtraLarge),
      if (tabletSmall != null) Node(BreakPoint.tabletSmall, tabletSmall),
      if (tabletNormal != null) Node(BreakPoint.tabletNormal, tabletNormal),
      if (tabletLarge != null) Node(BreakPoint.tabletLarge, tabletLarge),
      if (tabletExtraLarge != null)
        Node(BreakPoint.tabletExtraLarge, tabletExtraLarge),
      if (desktopSmall != null) Node(BreakPoint.desktopSmall, desktopSmall),
      if (desktopNormal != null) Node(BreakPoint.desktopNormal, desktopNormal),
      if (desktopLarge != null) Node(BreakPoint.desktopLarge, desktopLarge),
      if (desktopExtraLarge != null)
        Node(BreakPoint.desktopExtraLarge, desktopExtraLarge),
    ];

    final landscapeNodesList = [
      if (mobileSmallLandscape != null)
        Node(BreakPoint.mobileSmall, mobileSmallLandscape),
      if (mobileNormalLandscape != null)
        Node(BreakPoint.mobileNormal, mobileNormalLandscape),
      if (mobileLargeLandscape != null)
        Node(BreakPoint.mobileLarge, mobileLargeLandscape),
      if (mobileExtraLargeLandscape != null)
        Node(BreakPoint.mobileExtraLarge, mobileExtraLargeLandscape),
      if (tabletSmallLandscape != null)
        Node(BreakPoint.tabletSmall, tabletSmallLandscape),
      if (tabletNormalLandscape != null)
        Node(BreakPoint.tabletNormal, tabletNormalLandscape),
      if (tabletLargeLandscape != null)
        Node(BreakPoint.tabletLarge, tabletLargeLandscape),
      if (tabletExtraLargeLandscape != null)
        Node(BreakPoint.tabletExtraLarge, tabletExtraLargeLandscape),
      if (desktopSmallLandscape != null)
        Node(BreakPoint.desktopSmall, desktopSmallLandscape),
      if (desktopNormalLandscape != null)
        Node(BreakPoint.desktopNormal, desktopNormalLandscape),
      if (desktopLargeLandscape != null)
        Node(BreakPoint.desktopLarge, desktopLargeLandscape),
      if (desktopExtraLargeLandscape != null)
        Node(BreakPoint.desktopExtraLarge, desktopExtraLargeLandscape),
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
        BreakPoint.mobileSmall,
        'SizeHelper: ${f(current, BreakPoint.mobileSmall)} mobileSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.mobileNormal,
        'SizeHelper: ${f(current, BreakPoint.mobileNormal)} mobileNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.mobileLarge,
        'SizeHelper: ${f(current, BreakPoint.mobileLarge)} mobileLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.mobileExtraLarge,
        'SizeHelper: ${f(current, BreakPoint.mobileExtraLarge)} mobileExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.tabletSmall,
        'SizeHelper: ${f(current, BreakPoint.tabletSmall)} tabletSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.tabletNormal,
        'SizeHelper: ${f(current, BreakPoint.tabletNormal)} tabletNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.tabletLarge,
        'SizeHelper: ${f(current, BreakPoint.tabletLarge)} tabletLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.tabletExtraLarge,
        'SizeHelper: ${f(current, BreakPoint.tabletExtraLarge)} tabletExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.desktopSmall,
        'SizeHelper: ${f(current, BreakPoint.desktopSmall)} desktopSmall | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.desktopNormal,
        'SizeHelper: ${f(current, BreakPoint.desktopNormal)} desktopNormal | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.desktopLarge,
        'SizeHelper: ${f(current, BreakPoint.desktopLarge)} desktopLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
      ),
      Node(
        BreakPoint.desktopExtraLarge,
        'SizeHelper: ${f(current, BreakPoint.desktopExtraLarge)} desktopExtraLarge | Width: ${size.width} | Height: ${size.height} | Orientation: $orientationText',
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
