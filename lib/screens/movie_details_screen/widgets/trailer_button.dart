import 'package:flutter/material.dart';

class TrailerButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const TrailerButton({
    super.key,
    required this.onTap,
    this.text = "Ver tráiler",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity, // Ocupa todo el ancho disponible
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        alignment: Alignment.center, // Centra el texto e ícono
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
