import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

///[DraggableSwipingCard] is a widget that one can swipe to left or right
///to perform particular action on these events
class DraggableSwipingCard extends StatefulWidget {
  const DraggableSwipingCard({
    Key? key,
    this.threshold = 0.60,
    required this.child,
    required this.onTap,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  }) : super(key: key);

  ///[threshold] indicates how much swipe needs to happen
  ///for it to be considered as complete for action to be called
  ///the value must be between 0.0 and 1.0, deufalt is 0.60
  final double threshold;

  ///[child] is the actual content of the card
  final Widget child;

  ///[onTap] called when user taps on the card
  final void Function() onTap;

  ///[onSwipeLeft] called when the card is swipped from right to left
  final void Function() onSwipeLeft;

  ///[onSwipeRight] called when the card is swipped from left to right
  final void Function() onSwipeRight;

  @override
  _DraggableSwipingCardState createState() => _DraggableSwipingCardState();
}

class _DraggableSwipingCardState extends State<DraggableSwipingCard>
    with SingleTickerProviderStateMixin {
  final Alignment _defaultAlignment = Alignment.center;

  ///[_removed] indicates if the card is considered to be removed
  ///preventing it from regaining its original position before being removed
  bool _removed = false;

  ///[_dragAlignment] indicates the drag in X and Y axis
  ///default its set to [Alignment.center]
  Alignment _dragAlignment = Alignment.center;

  ///Animation and controller for the alignment animation
  ///late to be initialized in the [initState] method
  late Animation<Alignment> _animation;
  late AnimationController _animationController;

  ///[_runAnimation] starts the re-alignment animation
  ///that repositions the card to center
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _animationController.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: _defaultAlignment,
      ),
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    // For the center gravity / spring effect
    const gravitySpring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(gravitySpring, 0, 1, -unitVelocity);

    // Start animating
    _animationController.animateWith(simulation);
  }

  ///[_stopAnimation] stops the alignment animation
  void _stopAnimation() {
    if (_animationController.isAnimating) _animationController.stop();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);

    // Adding listener to the animation controller to rebuild widget tree for drag alignment udpate
    _animationController.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Widget placeCard = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: widget.onTap,
        child: widget.child,
      ),
    );

    return GestureDetector(
      onPanStart: (details) {
        // To stop any ongoing animation before updating
        _stopAnimation();
      },
      onPanUpdate: (details) {
        // Add new drag value to the alignment
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 16),
            details.delta.dy / (size.height / 4),
          );
        });
        // Check if considered to be removed
        if (!_removed) {
          // If dragged enough to consider complete left swipe
          if (_dragAlignment.x < -10.0) {
            setState(() {
              _dragAlignment += Alignment(
                -20 / (size.width / 2),
                details.delta.dy / (size.height / 2),
              );
            });
          }
          // If dragged enough to consider complete right swipe
          else if (_dragAlignment.x > 10) {
            setState(() {
              _dragAlignment += Alignment(
                20 / (size.width / 2),
                details.delta.dy / (size.height / 2),
              );
            });
          }
        }
      },
      onPanEnd: (details) {
        // If dragged enough to consider complete left swipe and call onSwipeLeft event
        if (_dragAlignment.x < -10.0) {
          _removed = true;
          widget.onSwipeLeft();
        }
        // If dragged enough to consider complete right swipe and call onSwipeRight event
        else if (_dragAlignment.x > 10) {
          _removed = true;
          widget.onSwipeRight();
        }
        // Re position card to center
        else {
          _runAnimation(
            details.velocity.pixelsPerSecond,
            size,
          );
        }
      },
      child: Align(
        alignment: _dragAlignment,
        child: placeCard,
      ),
    );

    ///Below code is simple and more optimized but does not gives the
    ///animated effect while repositioning to center after user ends dragging
    return Draggable(
      onDragEnd: (details) {
        ///Checking if the swipe is from right to left
        if (details.offset.dx.isNegative &&
            details.offset.dx.abs() / MediaQuery.of(context).size.width >
                widget.threshold) {
          widget.onSwipeLeft();

          ///Checking if the swipe is from left to right
        } else if (details.offset.dx / MediaQuery.of(context).size.width >
            widget.threshold) {
          widget.onSwipeRight();
        }
        // Doing nothing when both conditions no condition is true
      },
      childWhenDragging: SizedBox(),
      feedback: placeCard,
      child: placeCard,
    );
  }
}
