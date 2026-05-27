import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class PrivacyPolicyView extends GetView<SettingsController> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Theme.of(context).iconTheme.color, size: 28),
          onPressed: controller.goBack,
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Data Collection',
              'Hourly Chime collects minimal personal information to provide you with the best experience. We only collect information that is necessary for the app to function properly.',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Information We Collect',
              '• Chime settings and preferences\n• Usage analytics to improve the app\n• Device information for compatibility\n• No personal identifiers or sensitive data',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'How We Use Your Data',
              '• To provide and maintain our service\n• To notify you about app updates\n• To analyze usage patterns for improvements\n• To ensure app security and stability',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Data Storage & Security',
              'All your data is stored locally on your device. We do not store or transmit any personal information to external servers. Your chime settings and preferences remain private and secure on your device.',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Third-Party Services',
              'Hourly Chime may use third-party services for:\n• Analytics to understand app usage\n• Crash reporting to improve stability\n• These services do not have access to personal data',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Your Rights',
              'You have the right to:\n• Access your data stored in the app\n• Delete all app data and settings\n• Opt-out of analytics (in settings)\n• Request data export',context
            ),

            SizedBox(height: 24.h),
            _buildSection(
              'Children\'s Privacy',
              'Our app does not collect any personal information from children under 13. We are committed to protecting children\'s privacy online.',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy in the app.',context
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\nsupport@hourlychime.com',context
            ),
            SizedBox(height: 32.h),
            _buildLastUpdated(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content,context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            'Last Updated',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'December 15, 2023',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
