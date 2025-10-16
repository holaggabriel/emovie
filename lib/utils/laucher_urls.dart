
import 'package:emovie/utils/debug_print.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> customLaunchUrl(String urlString) async {
      final Uri url = Uri.parse(urlString);
      try {
        final bool launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          printInDebugMode('Could not launch $url');
          return false;
        } else {
          return true;
        }
      } catch (e) {
        printInDebugMode('Error launching $url: $e');
        return false;
      }
    }
