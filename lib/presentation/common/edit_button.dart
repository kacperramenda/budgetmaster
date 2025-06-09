import 'package:flutter/material.dart';

class RoundEditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RoundEditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFF3629B6), // #3629B6
          elevation: 0,
        ),
        child: const Icon(
          Icons.edit,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
