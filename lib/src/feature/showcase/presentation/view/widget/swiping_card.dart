import 'package:flutter/material.dart';

class SwipingCard extends StatelessWidget {
  SwipingCard({
    Key? key,
    this.threshold = 0.60,
    required this.child,
    this.childWhileSwiping,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  }) : super(key: key);

  final double threshold;
  final Widget? childWhileSwiping;
  final Widget child;
  void Function() onSwipeLeft;
  void Function() onSwipeRight;

  @override
  Widget build(BuildContext context) {
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
      feedback: child,
      child: child,
    );
  }
}
