import 'package:flutter/material.dart';
import 'app_info_page.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInfoPage(
      title: 'Privacy Policy',
      tagline: 'Your chimes stay on your device. Always.',
      sections: const [
        InfoSection(
          'Overview',
          'This Privacy Policy explains how ${AppInfo.appName} ("we", "our", or "us") handles information when you use our mobile application '
          '"${AppInfo.appName}" (package name: ${AppInfo.packageName}). By using the app, you agree to the practices described below.',
        ),
        InfoSection(
          'Information You Create in the App',
          '• Chime names, times, repeat days, sound and vibration preferences\n'
          '• Custom sound files that you record or import\n'
          '• App settings such as theme, volume and quiet hours\n\n'
          'This information is stored locally on your device. The app does not require an account and we do not upload your chime data to our servers.',
        ),
        InfoSection(
          'Information Collected Automatically',
          '• Device model, operating system and language\n'
          '• Anonymous usage events, such as screens opened and features used\n'
          '• Crash and performance diagnostics\n\n'
          'This information is collected through Firebase Analytics and Firebase Remote Config and is used only to understand app usage, fix issues and improve the experience.',
        ),
        InfoSection(
          'Permissions We Request',
          '• Notifications – to deliver your scheduled chimes\n'
          '• Exact alarms / schedule – to fire chimes on time\n'
          '• Vibration – for chime vibration\n'
          '• Microphone – only while you record a custom chime sound\n'
          '• Storage / media – only when you pick an audio file for a chime\n'
          '• Battery optimization exemption – to keep chimes working when the app is closed\n\n'
          'Permissions are requested only when needed and can be changed at any time in your device settings.',
        ),
        InfoSection(
          'Advertising and Third-Party Services',
          'Reminders is free and supported by ads. We use Google AdMob, Meta Audience Network (Facebook) and third-party ad networks to display ads. '
          'These partners may collect a device advertising identifier and technical information such as device type, operating system and general location '
          'to show and measure ads. Their handling of data is governed by their own privacy policies:\n\n'
          '• Google: https://policies.google.com/technologies/ads\n'
          '• Meta: https://www.facebook.com/privacy/policy',
        ),
        InfoSection(
          'Firebase Services',
          'We use Firebase Remote Config to manage app and ad settings, and Firebase Analytics to understand how the app is used. '
          'Firebase may collect device identifiers, app usage events and diagnostic data. No chime content or custom sound files are sent to Firebase.',
        ),
        InfoSection(
          'Data Sharing',
          'We do not sell your personal information. Information is shared only with service providers that help us run the app '
          '(analytics, advertising and diagnostics), or when required by law or to protect our rights.',
        ),
        InfoSection(
          'Data Storage and Security',
          'Chime data, custom sounds and preferences are stored on your device. We use reasonable measures to protect information, '
          'but no method of electronic storage is completely secure. You are responsible for keeping your device protected.',
        ),
        InfoSection(
          'Data Retention and Deletion',
          'Your chimes and settings remain on your device until you delete them. Deleting a chime, clearing app data or uninstalling the app removes that local data. '
          'To request deletion of analytics data associated with your device, contact us using the details below.',
        ),
        InfoSection(
          'Children\'s Privacy',
          'Reminders is not directed to children under 13. We do not knowingly collect personal information from children. '
          'If you believe a child has provided us with information, contact us and we will remove it.',
        ),
        InfoSection(
          'Your Choices and Rights',
          '• Edit or delete any chime from the app at any time\n'
          '• Turn notifications off from device settings\n'
          '• Opt out of personalized ads from your device ad settings (Android: Settings → Google → Ads)\n'
          '• Contact us to request access to or deletion of your data',
        ),
        InfoSection(
          'Changes to This Policy',
          'We may update this Privacy Policy from time to time. The updated policy will be posted in the app. '
          'Continued use of the app after changes means you accept the updated policy.',
        ),
      ],
    );
  }
}
