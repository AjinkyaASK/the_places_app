import 'package:flutter/material.dart';

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

  final double threshold;
  final Widget? childWhileSwiping;
  final Widget child;
  final void Function() onTap;
  final void Function() onSwipeLeft;
  final void Function() onSwipeRight;

  @override
  Widget build(BuildContext context) {
    final Widget newCard = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
    return Draggable(
      onDragEnd: (details) {
        if (details.offset.dx.isNegative &&
            details.offset.dx.abs() / MediaQuery.of(context).size.width >
                threshold) {
          onSwipeLeft();
        } else if (details.offset.dx / MediaQuery.of(context).size.width >
            threshold) {
          onSwipeRight();
        }
      },
      childWhenDragging: childWhileSwiping ?? SizedBox(),
      feedback: newCard,
      child: newCard,
    );
  }
}
