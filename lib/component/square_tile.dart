import 'package:flutter/material.dart';
import 'package:myapp/login.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Login())
        );
      },
      child: Image.asset(
        imagePath,
        width: 60,
        height: 60
      ),
    );
  }
}