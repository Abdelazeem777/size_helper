import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show BuildContext, Size, SizedBox, Widget;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:size_helper/size_helper.dart';

class MockStatefulElement extends Mock implements StatefulElement {
  MockStatefulElement(StatefulWidget widget)
      : state = widget.createState(),
        super(widget) {
    assert(() {
      if (!state._debugTypesAreRight(widget)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('StatefulWidget.createState must return a subtype of State<${widget.runtimeType}>'),
          ErrorDescription(
            'The createState function for ${widget.runtimeType} returned a state '
            'of type ${state.runtimeType}, which is not a subtype of '
            'State<${widget.runtimeType}>, violating the contract for createState.',
          ),
        ]);
      }
      return true;
    }());

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

main() {
  test('Returns mobileSmall choice', () {
    final context = _createContextWithSize(150.0, 300.0);
    final result = SizeHelper.of(context).help(
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
    final result = SizeHelper.of(context).help(
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
    final result = SizeHelper.of(context).help(
      mobileSmall: 'wrong',
      mobileNormal: 'wrong',
      tabletExtraLarge: 'right',
    );

    expect(result, 'right');
  });
}

BuildContext _createContextWithSize(double width, double height) {
  final context = MockStatefulElement();
  when(context.widget).thenReturn(
    MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: MaterialApp(),
    ),
  );
  return StatelessElement(TestStatelessWidget());
}

class TestStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
