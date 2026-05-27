import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class OurAppsView extends GetView<SettingsController> {
  const OurAppsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xFF0E0F12) : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? const Color(0xFF0E0F12) : Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Get.isDarkMode ? Colors.white : Colors.black87, size: 28),
          onPressed: controller.goBack,
        ),
        title: Text(
          'Our Apps',
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black87,
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
            Text(
              'Discover More Apps',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our collection of productivity and lifestyle apps',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Apps Grid
            _buildAppsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppsGrid() {
    final apps = [
      AppInfo(
        name: 'Focus Timer',
        description: 'Stay focused and boost productivity with Pomodoro technique',
        icon: Icons.timer_outlined,
        color: const Color(0xFF2979FF),
        rating: 4.5,
        downloads: '100K+',
      ),
      AppInfo(
        name: 'Task Manager',
        description: 'Organize your tasks and boost your daily productivity',
        icon: Icons.task_alt_outlined,
        color: const Color(0xFF00C853),
        rating: 4.3,
        downloads: '50K+',
      ),
      AppInfo(
        name: 'Mood Tracker',
        description: 'Track your daily mood and improve mental wellness',
        icon: Icons.mood_outlined,
        color: const Color(0xFFFF6D00),
        rating: 4.7,
        downloads: '75K+',
      ),
      AppInfo(
        name: 'Habit Builder',
        description: 'Build good habits and break bad ones with daily tracking',
        icon: Icons.trending_up_outlined,
        color: const Color(0xFF9C27B0),
        rating: 4.4,
        downloads: '80K+',
      ),
      AppInfo(
        name: 'Sleep Tracker',
        description: 'Monitor your sleep patterns and improve sleep quality',
        icon: Icons.bedtime_outlined,
        color: const Color(0xFF3F51B5),
        rating: 4.6,
        downloads: '60K+',
      ),
      AppInfo(
        name: 'Water Reminder',
        description: 'Stay hydrated with smart water intake reminders',
        icon: Icons.local_drink_outlined,
        color: const Color(0xFF00BCD4),
        rating: 4.2,
        downloads: '120K+',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) => _buildAppCard(apps[index]),
    );
  }

  Widget _buildAppCard(AppInfo app) {
    return GestureDetector(
      onTap: () => controller.openApp(app.name),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Icon
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  app.icon,
                  color: app.color,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 12.h),
              
              // App Name
              Text(
                app.name,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              
              // Description
              Text(
                app.description,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 12.sp,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              
              // Rating and Downloads
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFFFD700),
                        size: 12.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        app.rating.toString(),
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    app.downloads,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white54 : Colors.black38,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppInfo {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final double rating;
  final String downloads;

  AppInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.rating,
    required this.downloads,
  });
}
