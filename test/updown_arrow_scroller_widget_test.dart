import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:updown_arrow_scroller/updown_arrow_scroller.dart';

void main() {
  test('adds one to input values', () {
    UpDownArrowScroller(
      childScrollController: ScrollController(),
      child: Container(),
    );
  });
}
