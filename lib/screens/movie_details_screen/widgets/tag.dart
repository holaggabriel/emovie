import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? leadingIcon;
  final FontWeight fontWeight;
  final double fontSize;

  const Tag({
    super.key,
    required this.text,
    this.backgroundColor = Colors.white70,
    this.textColor = Colors.black,
    this.leadingIcon,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 4)],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
