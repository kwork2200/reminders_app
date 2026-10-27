import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../ads/ad_on_back_wrapper.dart';
import '../../ads/hybrid_banner_ad_widget.dart';
import 'theme_controller.dart';

class ThemeView extends GetView<ThemeController> {
  const ThemeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdOnBackWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0F12),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E0F12),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Theme',
            style: TextStyle(
              color: Colors.white,
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
              const Text(
                'Choose Theme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your preferred theme appearance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 32.h),
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

  // Widget _buildThemeOption({
  //   required String title,
  //   required String subtitle,
  //   required IconData icon,
  //   required String themeName,
  // }) {
  //   return Obx(() {
  //     // final isSelected = controller.currentTheme.value == themeName;
  //
  //     return GestureDetector(
  //       onTap: () => controller.setTheme(themeName),
  //       child: Container(
  //         padding: EdgeInsets.all(20.w),
  //         decoration: BoxDecoration(
  //           color: isSelected
  //               ? const Color(0xFF2979FF).withOpacity(0.1)
  //               : const Color(0xFF1A1C22),
  //           borderRadius: BorderRadius.circular(16.r),
  //           border: Border.all(
  //             color: isSelected
  //                 ? const Color(0xFF2979FF)
  //                 : const Color(0xFF2C2C3E),
  //             width: isSelected ? 2 : 1,
  //           ),
  //         ),
  //         child: Row(
  //           children: [
  //             // Icon Container
  //             Container(
  //               width: 48.w,
  //               height: 48.h,
  //               decoration: BoxDecoration(
  //                 color: isSelected
  //                     ? const Color(0xFF2979FF).withOpacity(0.2)
  //                     : const Color(0xFF2C2C3E),
  //                 borderRadius: BorderRadius.circular(12.r),
  //               ),
  //               child: Icon(
  //                 icon,
  //                 color: isSelected
  //                     ? const Color(0xFF2979FF)
  //                     : Colors.white70,
  //                 size: 24.sp,
  //               ),
  //             ),
  //
  //             SizedBox(width: 16.w),
  //
  //             // Text Content
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: TextStyle(
  //                       color: isSelected
  //                           ? const Color(0xFF2979FF)
  //                           : Colors.white,
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   SizedBox(height: 4.h),
  //                   Text(
  //                     subtitle,
  //                     style: TextStyle(
  //                       color: Colors.white70,
  //                       fontSize: 13.sp,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             // Selection Indicator
  //             if (isSelected)
  //               Container(
  //                 width: 24.w,
  //                 height: 24.h,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFF2979FF),
  //                   borderRadius: BorderRadius.circular(12.r),
  //                 ),
  //                 child: const Icon(
  //                   Icons.check,
  //                   color: Colors.white,
  //                   size: 16,
  //                 ),
  //               )
  //             else
  //               Container(
  //                 width: 24.w,
  //                 height: 24.h,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFF2C2C3E),
  //                   borderRadius: BorderRadius.circular(12.r),
  //                   border: Border.all(
  //                     color: const Color(0xFF3A3A4C),
  //                     width: 1,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
}
