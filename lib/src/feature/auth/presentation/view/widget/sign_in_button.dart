import 'package:flutter/material.dart';

///[SignInButton] provides a custom styled button widget
///for all sign in buttons
class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.loading = false,
    this.leading,
  }) : super(key: key);

  ///[onPressed] executed when user taps on the button
  final void Function()? onPressed;

  ///[leading] is shown at left side before text
  ///not visible when [loading] is set to true
  final Widget? leading;

  ///When [loading] is true a spinner shown at leading position
  ///When loader is shown [leading] widget is not visible
  ///default value is `false`
  final bool loading;

  ///[text] is the label of the button
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 200.0,
      onPressed: onPressed,
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ),
                ),
              )
            else if (leading != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: leading,
              ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
