import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? leadingIcon;
  final FontWeight fontWeight;
  final double fontSize; // Nuevo parámetro opcional

  const Tag({
    super.key,
    required this.text,
    this.backgroundColor = Colors.black54,
    this.textColor = Colors.white,
    this.leadingIcon,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 12, // Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize, // Usamos el parámetro opcional
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}