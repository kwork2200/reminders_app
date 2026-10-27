import 'package:flutter/material.dart';
import 'app_info_page.dart';

class TermsView extends StatelessWidget {
  const TermsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInfoPage(
      title: 'Terms & Conditions',
      tagline: 'A few simple rules for using Reminders.',
      showContactCard: false,
      sections: const [
        InfoSection(
          'Acceptance of Terms',
          'By downloading, installing or using the ${AppInfo.appName} app (package name: ${AppInfo.packageName}), you agree to these Terms & Conditions. '
          'If you do not agree, please do not use the app.',
        ),
        InfoSection(
          'Description of the Service',
          'Reminders lets you create gentle chime reminders with custom times, repeat days, sounds and vibration, along with quiet hours, volume and theme settings. '
          'The app is free to use and supported by ads. Some features may be added, changed or removed over time.',
        ),
        InfoSection(
          'License to Use',
          'We grant you a personal, non-exclusive, non-transferable and revocable license to use Reminders for personal, non-commercial purposes. '
          'You may not copy, modify, reverse engineer, resell or redistribute the app or any part of it.',
        ),
        InfoSection(
          'Your Responsibilities',
          '• Configure your chimes, time zone and device settings correctly\n'
          '• Grant the permissions needed for chimes to work (notifications, alarms, battery optimization)\n'
          '• Keep your device powered on and not force-stopped if you rely on a chime\n\n'
          'Reminders is a gentle reminder tool. Do not rely on it as the only method for critical, medical, safety or time-sensitive reminders.',
        ),
        InfoSection(
          'Notifications, Alarms and Device Restrictions',
          'Chimes may be delayed or blocked by Do Not Disturb or silent mode settings, battery optimization, operating system restrictions, low power mode, '
          'force-stopping the app, device restart, or the device being switched off. We are not responsible for missed or delayed chimes caused by such conditions.',
        ),
        InfoSection(
          'Ads and Third-Party Services',
          'The app displays ads through Google AdMob, Meta Audience Network (Facebook) and third-party ad networks. '
          'Any interaction with an ad or an external website is at your own discretion and is governed by that provider\'s terms and privacy policy.',
        ),
        InfoSection(
          'Premium Features',
          'Premium plans may be shown inside the app. At present the upgrade is not available and no payment is processed. '
          'Before any paid feature is introduced, its price, billing terms and cancellation details will be shown clearly.',
        ),
        InfoSection(
          'Intellectual Property',
          'The app, its name, logo, design and built-in content belong to the developer of ${AppInfo.appName}. '
          'Sounds that you record or import remain yours; you are responsible for having the right to use them.',
        ),
        InfoSection(
          'Prohibited Uses',
          'You agree not to use the app for unlawful purposes, to disrupt or damage the app or its services, to distribute modified copies, '
          'or to attempt to access data that does not belong to you.',
        ),
        InfoSection(
          'Disclaimer of Warranties',
          'The app is provided "as is" and "as available", without warranties of any kind, whether express or implied, including fitness for a particular purpose, '
          'accuracy or uninterrupted availability.',
        ),
        InfoSection(
          'Limitation of Liability',
          'To the maximum extent permitted by law, we are not liable for any indirect, incidental or consequential damages, including missed reminders, '
          'loss of data or loss of profits arising from the use of, or inability to use, the app.',
        ),
        InfoSection(
          'Termination',
          'We may suspend or terminate access to the app if these terms are violated or if the app is discontinued. '
          'You may stop using the app at any time by uninstalling it.',
        ),
        InfoSection(
          'Governing Law',
          'These Terms are governed by the laws of India. Any dispute will be subject to the jurisdiction of the courts in Gujarat, India.',
        ),
        InfoSection(
          'Changes to These Terms',
          'We may update these Terms & Conditions from time to time. The updated terms will be posted in the app. '
          'Continued use of the app after changes means you accept the updated terms.',
        ),
      ],
    );
  }
}
