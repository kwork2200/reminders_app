import 'package:flutter/material.dart';
import 'app_info_page.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInfoPage(
      title: 'About Us',
      tagline: 'Gentle time signals, right on time.',
      badge: 'Made with care',
      showContactCard: false,
      sections: const [
        InfoSection(
          'What is Reminders?',
          'Reminders is a calm, simple reminder app that brings gentle time signals back into your day. '
          'Instead of noisy alerts, you get soft chimes at the moments you choose — to drink water, stand up, breathe, or simply pause and reset.',
        ),
        InfoSection(
          'What You Can Do',
          '• Create chimes with your own time and repeat days\n'
          '• Choose built-in sounds, record your own, or import an audio file\n'
          '• Add vibration and control chime volume\n'
          '• Set quiet hours to silence chimes when you need rest\n'
          '• Switch between light, dark or system theme',
        ),
        InfoSection(
          'Private by Design',
          'Your chimes, custom sounds and settings are stored locally on your device. '
          'There is no account to create and your chime data is not uploaded to our servers. '
          'The app is supported by ads, which keeps Reminders free to use.',
        ),
        InfoSection(
          'App Details',
          'App name: ${AppInfo.appName}\n'
          'Package name: ${AppInfo.packageName}\n'
          'Platform: Android\n'
          'Developer: ${AppInfo.appName} Team',
        ),
        InfoSection(
          'We Would Love Your Feedback',
          'Have an idea, found a bug, or want a feature? Send it from Settings → Contact Us. '
          'Your feedback directly shapes the next updates of the app.',
        ),
      ],
    );
  }
}
