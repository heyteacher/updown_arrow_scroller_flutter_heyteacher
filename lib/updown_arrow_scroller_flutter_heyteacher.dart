import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Scrolls child widget on press of up and down arrow or page key of Keyboard
class UpDownArrowScroller extends StatefulWidget {
  /// Creates a [UpDownArrowScroller] on [_child].
  ///
  /// If up or down arrow key is pressed, scollbar is moved up or down of
  /// [_arrowOffset] pixels (default [defaultArrowOffset]).
  ///
  /// If up or down page key is pressed, scrollbar in moved up or down of
  /// [_child] height.
  ///
  /// The movement is animated with a [_animationDurationInMilliseconds]
  /// milliseconds duration (default [defaultAnimationDurationInMilliseconds]).
  const UpDownArrowScroller({
    required this._childScrollController,
    required this._child,
    this._arrowOffset = defaultArrowOffset,
    this._animationDurationInMilliseconds =
        defaultAnimationDurationInMilliseconds,
    super.key,
  });

  /// The default arrow offset in pixels
  static const defaultArrowOffset = 100;

  /// The default animation duration in milliseconds
  static const defaultAnimationDurationInMilliseconds = 100;

  final ScrollController _childScrollController;
  final Widget _child;
  final int _arrowOffset;
  final int _animationDurationInMilliseconds;

  @override
  State<UpDownArrowScroller> createState() => _UpDownArrowScrollerState();
}

class _UpDownArrowScrollerState extends State<UpDownArrowScroller> {
  final FocusNode _focusNode = FocusNode();

  static const List<LogicalKeyboardKey> _arrowsKeys = [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.pageUp,
    LogicalKeyboardKey.pageDown,
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    focusNode: _focusNode,
    onKeyEvent: _handleKeyEvent,
    autofocus: true,
    child: widget._child,
  );

  void _handleKeyEvent(KeyEvent event) =>
      event is KeyDownEvent && _arrowsKeys.contains(event.logicalKey)
      ? setState(() {
          widget._childScrollController.animateTo(
            widget._childScrollController.offset +
                _offset(context: context, keyboardKey: event.logicalKey),
            duration: Duration(
              milliseconds: widget._animationDurationInMilliseconds,
            ),
            curve: Curves.ease,
          );
        })
      : null;

  double _offset({
    required BuildContext context,
    required KeyboardKey keyboardKey,
  }) {
    assert(
      _arrowsKeys.contains(keyboardKey),
      'logicalKeyboardKey $keyboardKey not in $_arrowsKeys',
    );
    switch (keyboardKey) {
      case LogicalKeyboardKey.arrowUp:
        return -widget._arrowOffset.toDouble();
      case LogicalKeyboardKey.arrowDown:
        return widget._arrowOffset.toDouble();
      case LogicalKeyboardKey.pageUp:
        return -(context.size?.height ?? 0);
      case LogicalKeyboardKey.pageDown:
        return context.size?.height ?? 0;
      default:
        return 0;
    }
  }
}
