import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget? navigateTo;
  final String? buttonText;
  final Color backgroundColor;
  final Color color;
  final VoidCallback? onPressed;

  const Button(
      {super.key,
      this.buttonText,
      this.navigateTo,
      required this.backgroundColor,
      required this.color,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 23),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!(); // Execute custom function
        } else if (navigateTo != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigateTo!),
          );
        }
      },
      child: Text(
        buttonText!,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
