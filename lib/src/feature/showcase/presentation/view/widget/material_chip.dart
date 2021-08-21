import 'package:flutter/material.dart';

///[MaterialChip] is a simple widget that shows rounded rectangle at background
///and a icon and text on top of it
class MaterialChip extends StatelessWidget {
  const MaterialChip({
    Key? key,
    this.icon,
    required this.label,
    this.color = Colors.white,
    this.backgroundColor = Colors.black87,
  }) : super(key: key);

  ///[icon] is shown at the left side and is optional
  final IconData? icon;

  ///[label] is the text of the chip
  final String label;

  ///[color] is set as a color of text and icon
  final Color color;

  ///[backgroundColor] is set as the backround color of the rounded rectangle of chip
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  icon,
                  size: 14.0,
                  color: color.withOpacity(0.8),
                ),
              ),
            Flexible(
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        decoration: TextDecoration.none,
                        color: color,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
