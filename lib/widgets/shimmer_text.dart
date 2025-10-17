import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color baseColor;
  final Color highlightColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const ShimmerText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.baseColor = Colors.white70,
    this.highlightColor = Colors.white,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: baseColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
