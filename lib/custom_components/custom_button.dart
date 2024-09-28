import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      height: 48,
      child: TextButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
