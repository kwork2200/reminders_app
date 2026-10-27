import 'package:flutter/material.dart';
import 'app_info_page.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInfoPage(
      title: 'Contact Us',
      tagline: 'Questions, ideas or bugs — we listen.',
      badge: 'Support',
      sections: const [
        InfoSection(
          'We\'re Here to Help',
          'Have a question about ${AppInfo.appName}, found something that is not working, or want a new feature? '
          'Reach out to us — every message is read and every report helps improve the app.',
        ),
        InfoSection(
          'Email Support',
          'For questions, bug reports and feature requests, email us at ${AppInfo.email}. '
          'Please include a short description of the issue and, if possible, screenshots so we can help you faster.',
        ),
        InfoSection(
          'Call Us',
          'For urgent matters, call ${AppInfo.phone} between 10:00 AM and 7:00 PM (IST), Monday to Saturday.',
        ),
        InfoSection(
          'Report a Bug',
          '• Tell us what you did just before the problem appeared\n'
          '• Share your device model and operating system\n'
          '• Attach a screenshot or screen recording if possible\n\n'
          'We will look into it and keep you updated on the fix.',
        ),
        InfoSection(
          'Feature Requests',
          'We love hearing how you use ${AppInfo.appName}. If there is a sound, habit or setting you would like to see, '
          'send it our way — many improvements come directly from user suggestions.',
        ),
        InfoSection(
          'Response Time',
          'We usually reply within 24–48 hours. Messages sent on Sundays or public holidays may take a little longer.',
        ),
      ],
    );
  }
}
