import 'package:flutter/material.dart';
import 'package:emovie/utils/laucher_urls.dart';

class MyAboutDialog extends StatelessWidget {
  const MyAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.36)),
      title: const Text(
        'eMovie',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 25,
        ),
      ),
      content: GestureDetector(
        onTap: () async {
          await customLaunchUrl('https://github.com/holaggabriel/emovie');
        },
        child: RichText(
          text: TextSpan(
            text: 'Visita nuestro GitHub',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // <- subrayado
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
