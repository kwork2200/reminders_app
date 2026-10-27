import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ads/ad_on_back_wrapper.dart';
import '../../ads/hybrid_banner_ad_widget.dart';

class AppInfo {
  static const appName = 'Reminders';
  static const packageName = 'com.reminders.reminder_app';
  static const email = 'vaghasiyasanket36@gmail.com';
  static const phone = '+91 97260 30303';
  static const phoneDial = '+919726030303';
}

class InfoSection {
  final String title;
  final String body;

  const InfoSection(this.title, this.body);
}

class AppInfoPage extends StatelessWidget {
  final String title;
  final String tagline;
  final String? badge;
  final List<InfoSection> sections;
  final bool showContactCard;

  const AppInfoPage({
    super.key,
    required this.title,
    required this.tagline,
    this.badge,
    required this.sections,
    this.showContactCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return AdOnBackWrapper(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).iconTheme.color,
              size: 28,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            title,
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
              _buildHeader(context),
              SizedBox(height: 24.h),
              for (var i = 0; i < sections.length; i++) ...[
                _buildSection(context, sections[i]),
                if (i != sections.length - 1) SizedBox(height: 16.h),
              ],
              SizedBox(height: 24.h),
              if (showContactCard) ...[
                _buildContactCard(context),
                SizedBox(height: 24.h),
              ],
              // Center(
              //   child: Text(
              //     '© 2026 ${AppInfo.appName} • ${AppInfo.packageName}',
              //     style: TextStyle(
              //       color: (Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.6),
              //       fontSize: 11.sp,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // SizedBox(height: 24.h),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: const HybridBannerAdWidget(),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF2979FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppInfo.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  tagline,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                if (badge != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      badge!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, InfoSection section) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            section.body,
            style: TextStyle(
              color: (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey).withOpacity(0.85),
              fontSize: 14.sp,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: color, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                'Contact Us',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'We usually reply within 24–48 hours.',
            style: TextStyle(
              color: (Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _buildContactRow(
            context,
            icon: Icons.mail_outline,
            label: 'Email',
            value: AppInfo.email,
            uri: 'mailto:${AppInfo.email}',
          ),
          _buildContactRow(
            context,
            icon: Icons.call_outlined,
            label: 'Phone',
            value: AppInfo.phone,
            uri: 'tel:${AppInfo.phoneDial}',
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            height: 20.h,
          ),
          Text(
            'App: ${AppInfo.appName}',
            // 'App: ${AppInfo.appName}  •  ${AppInfo.packageName}',
            style: TextStyle(
              color: (Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.7),
              fontSize: 11.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String uri,
  }) {
    final color = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => _open(uri),
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: (Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey).withOpacity(0.8),
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(String uri) async {
    final parsed = Uri.parse(uri);
    if (await canLaunchUrl(parsed)) {
      await launchUrl(parsed, mode: LaunchMode.externalApplication);
    }
  }
}
