import 'package:flutter/material.dart';

///[SwipingCard] is a widget that one can swipe to left or right
///to perform particular action on these events
class SwipingCard extends StatelessWidget {
  const SwipingCard({
    Key? key,
    this.threshold = 0.60,
    required this.child,
    this.childWhileSwiping,
    required this.onTap,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  }) : super(key: key);

  ///[threshold] indicates how much swipe needs to happen
  ///for it to be considered as complete for action to be called
  ///the value must be between 0.0 and 1.0, deufalt is 0.60
  final double threshold;

  ///[childWhileSwiping] is a widget that is shown while swiping
  final Widget? childWhileSwiping;

  ///[child] is the actual content of the card
  final Widget child;

  ///[onTap] called when user taps on the card
  final void Function() onTap;

  ///[onSwipeLeft] called when the card is swipped from right to left
  final void Function() onSwipeLeft;

  ///[onSwipeRight] called when the card is swipped from left to right
  final void Function() onSwipeRight;

  @override
  Widget build(BuildContext context) {
    final Widget newCard = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: child,
      ),
    );
    return Draggable(
      onDragEnd: (details) {
        ///Checking if the swipe is from right to left
        if (details.offset.dx.isNegative &&
            details.offset.dx.abs() / MediaQuery.of(context).size.width >
                threshold) {
          onSwipeLeft();

          ///Checking if the swipe is from left to right
        } else if (details.offset.dx / MediaQuery.of(context).size.width >
            threshold) {
          onSwipeRight();
        }
        // Doing nothing when both conditions no condition is true
      },
      childWhenDragging: childWhileSwiping ?? SizedBox(),
      feedback: newCard,
      child: newCard,
    );
  }
}
