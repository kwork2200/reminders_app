import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7) ?? Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    _buildFirstPage(context),
                    _buildSecondPage(context),
                    _buildThirdPage(context),
                    _buildFourthPage(context),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                      children: List.generate(
                        3,
                        (index) => _buildDot(index == controller.currentPage.value,context),
                      ),
                    )),
                    Obx(() => ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        elevation: 5,
                        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                      child: Text(
                        controller.currentPage.value == 3 ? 'Get Started' : 'Next',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFirstPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text and Clock side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'In the rush of the day,\nwe forget ourselves.',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 16.w),
              // Clock on the right side
              Container(
                height: 70.h,
                width: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4facfe),
                      const Color(0xFF00f2fe),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4facfe).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.access_time,
                  size: 35.sp,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          // Person illustration in middle - replace with actual image
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                'assets/images/onboarding1.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.desktop_windows,
                      size: 100.sp,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Descriptive text below
          Text(
            'Not our tasks. Not our deadlines.\nJust the simple things - water, breath,\na moment to reset. Hours pass\nbefore we even notice.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7) ?? Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Three bell panels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBellPanel(context, Icons.notifications_active, const Color(0xFF4facfe)),
              _buildBellPanel(context, Icons.circle_notifications, const Color(0xFF00f2fe)),
              _buildBellPanel(context, Icons.notification_important, const Color(0xFF6C63FF)),
            ],
          ),
          SizedBox(height: 60.h),
          // Text content
          Text(
            'Humans',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            'always had gentle time signals.\nJust to remind you.',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBellPanel(BuildContext context, IconData icon, Color color) {
    return Container(
      height: 180.h,
      width: 90.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50.sp,
            color: color,
          ),
          SizedBox(height: 12.h),
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(
              Icons.notifications,
              size: 20.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Phone mockup
          Container(
            height: 280.h,
            width: 160.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2C2C3E),
                  const Color(0xFF1E1E2E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Phone notch/status bar
                Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.r),
                      topRight: Radius.circular(22.r),
                    ),
                  ),
                ),
                // App content placeholder
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Default chime card
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Default Chime',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '10:00 AM',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Every Hour, Every Day',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Lunch time card
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lunch Time',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '01:00 PM',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Weekdays',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        // FAB placeholder
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 30.h,
                            width: 30.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          // Text above phone
          Text(
            'Hourly Chime brings that signal back.',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          // Text below phone
          Text(
            'A soft sound. Right on time. You already know what it means. Your chime. Your move.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFourthPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder - person at desk with clock
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 250.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Center(
                  child: Icon(
                    Icons.desktop_windows,
                    size: 120.sp,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              // Clock icon overlay
              Positioned(
                top: 20.h,
                left: 20.w,
                child: Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4facfe),
                        const Color(0xFF00f2fe),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4facfe).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.access_time,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          // Text above illustration
          Text(
            'You remember yourself.',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          // Text below illustration
          Text(
            'To drink water. To stand up. To breathe. Not because an app told you to. Because you remembered — on your own.',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white70,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
