import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reminders_app/core/theme/app_colors.dart';
import '../../data/firebase/admob_service.dart';
import '../../data/models/chime_model.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 20.w,
        title: Text(
          'Hourly Chime',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            child: ElevatedButton.icon(
              onPressed: controller.navigateToUpgrade,
              icon: Icon(
                Icons.workspace_premium,
                size: 18.sp,
                color: Colors.white,
              ),
              label: Text(
                'Upgrade',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C00),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                size: 26.sp,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.7) ?? Colors.white70,
              ),
              onPressed: controller.navigateToSettings,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: controller.isBannerAdLoaded.value ?Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.only(bottom: 10.h),
        height: 60.h,
        width: 100.h,
        child: Obx(() => _buildBannerAdWidget(context)),
      ):SizedBox.shrink(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildDefaultChimeCard(context),
                SizedBox(height: 28.h),
                _buildYourChimesSection(context),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: controller.testBackgroundService,
            heroTag: "test",
            mini: true,
            backgroundColor: Colors.orange,
            child: Icon(Icons.bug_report, size: 20.sp, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          FloatingActionButton(
            onPressed: controller.addChime,
            heroTag: "add",
            elevation: 4,
            child: Icon(Icons.add, size: 30.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultChimeCard(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color:  controller.isDefaultChimeEnabled.value ? const Color(0xFF00C853) :AppColors.red ,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Default Chime',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.isDefaultChimeEnabled.value 
                          ? Theme.of(context).textTheme.bodyLarge?.color 
                          : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                    ),
                  ),
                ],
              ),
              Switch(
                value: controller.isDefaultChimeEnabled.value,
                onChanged: controller.toggleDefaultChime,
                activeColor: Colors.white,
                activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
                inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Large time display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '06:00',
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w800,
                  color: controller.isDefaultChimeEnabled.value 
                      ? Theme.of(context).textTheme.bodyLarge?.color 
                      : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'PM',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: controller.isDefaultChimeEnabled.value 
                        ? Theme.of(context).textTheme.bodyLarge?.color 
                        : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Every Hour label
          Row(
            children: [
              Icon(
                Icons.sync,
                size: 16.sp,
                color: controller.isDefaultChimeEnabled.value 
                    ? Theme.of(context).iconTheme.color 
                    : Theme.of(context).iconTheme.color?.withOpacity(0.38),
              ),
              SizedBox(width: 6.w),
              Text(
                'Every Hour, Everyday',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: controller.isDefaultChimeEnabled.value
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildYourChimesSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.alarm_outlined,
              size: 22.sp,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.38) ?? Colors.white38,
            ),
            SizedBox(width: 8.w),
            Text(
              'Your Chimes',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Obx(() => controller.chimes.isEmpty
            ? _buildEmptyState(context)
            : _buildChimesList(context)),
          

      ],
    );
  }

  Widget _buildChimesList(context) {
    return Column(
      children: controller.chimes.map((chime) => _buildChimeCard(chime,context)).toList(),
    );
  }

  Widget _buildChimeCard(Chime chime,context) {
    return GestureDetector(
      onTap: () {
        controller.onChimeCardTap(chime.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: chime.isEnabled ? const Color(0xFF00C853) : AppColors.red,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      chime.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: chime.isEnabled 
                            ? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38) ?? Colors.white38,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: chime.isEnabled,
                  onChanged: (value) => controller.toggleChime(chime.id),
                  activeColor: Colors.white,
                  activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                  inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
                  inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  chime.formattedTime,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                    color: chime.isEnabled
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.sync,
                  size: 16.sp,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.38) ?? Colors.white38,
                ),
                SizedBox(width: 6.w),
                Text(
                  chime.formattedDays,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: chime.isEnabled
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.38),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerAdWidget(BuildContext context) {
    final adMobService = AdMobService();
    final bannerWidget = adMobService.getBannerAdWidget();
    
    // Use reactive state to check if banner ad is loaded
    if (controller.isBannerAdLoaded.value) {
      return bannerWidget;
    } else {
      return Text(
        'Ad loading...',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
          fontSize: 12.sp,
        ),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          SizedBox(
            width: 260.w,
            height: 200.h,
            child: CustomPaint(
              painter: _EmptyStatePainter(),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No custom chimes yet.',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.54) ?? Colors.white54,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add one below.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.38) ?? Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws the grayscale hourglass illustration
/// matching the screenshot's empty state art.
class _EmptyStatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Ground shadow ellipse ──
    final shadowPaint = Paint()
      ..color = const Color(0xFF2A2A3A)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + 40), width: 200, height: 50),
      shadowPaint,
    );

    // ── Hourglass body ──
    final glassPaint = Paint()
      ..color = const Color(0xFF3A3A4A)
      ..style = PaintingStyle.fill;

    // Top half trapezoid
    final topPath = Path()
      ..moveTo(cx - 36, cy - 70)
      ..lineTo(cx + 36, cy - 70)
      ..lineTo(cx + 10, cy)
      ..lineTo(cx - 10, cy)
      ..close();
    canvas.drawPath(topPath, glassPaint);

    // Bottom half trapezoid
    final bottomPath = Path()
      ..moveTo(cx - 10, cy)
      ..lineTo(cx + 10, cy)
      ..lineTo(cx + 36, cy + 60)
      ..lineTo(cx - 36, cy + 60)
      ..close();
    canvas.drawPath(bottomPath, glassPaint);

    // Top cap
    final capPaint = Paint()
      ..color = const Color(0xFF4A4A5A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy - 74), width: 80, height: 12),
        const Radius.circular(4),
      ),
      capPaint,
    );
    // Bottom cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy + 64), width: 80, height: 12),
        const Radius.circular(4),
      ),
      capPaint,
    );

    // Sand in bottom
    final sandPaint = Paint()
      ..color = const Color(0xFF5A5A6A)
      ..style = PaintingStyle.fill;
    final sandPath = Path()
      ..moveTo(cx - 8, cy + 10)
      ..lineTo(cx + 8, cy + 10)
      ..lineTo(cx + 30, cy + 58)
      ..lineTo(cx - 30, cy + 58)
      ..close();
    canvas.drawPath(sandPath, sandPaint);

    // Sand drip line
    final dripPaint = Paint()
      ..color = const Color(0xFF6A6A7A)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, cy), Offset(cx, cy + 12), dripPaint);

    // ── Orbit arrows ──
    final arrowPaint = Paint()
      ..color = const Color(0xFF555565)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Left arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 5), width: 110, height: 80),
      3.14 * 0.6,
      3.14 * 0.9,
      false,
      arrowPaint,
    );
    // Right arc
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 5), width: 110, height: 80),
      3.14 * -0.4,
      3.14 * 0.9,
      false,
      arrowPaint,
    );

    // ── Left small circle icon (crosshair) ──
    final iconPaint = Paint()
      ..color = const Color(0xFF4A4A5A)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final leftIconCenter = Offset(cx - 62, cy + 28);
    canvas.drawCircle(leftIconCenter, 18, iconPaint);
    canvas.drawLine(
        leftIconCenter.translate(-18, 0), leftIconCenter.translate(18, 0), iconPaint);
    canvas.drawLine(
        leftIconCenter.translate(0, -18), leftIconCenter.translate(0, 18), iconPaint);

    // ── Right larger circle icon (plus) ──
    final rightIconCenter = Offset(cx + 68, cy + 28);
    canvas.drawCircle(rightIconCenter, 22, iconPaint);
    canvas.drawLine(
        rightIconCenter.translate(-12, 0), rightIconCenter.translate(12, 0), iconPaint);
    canvas.drawLine(
        rightIconCenter.translate(0, -12), rightIconCenter.translate(0, 12), iconPaint);

    // ── Sparkle dots ──
    final dotPaint = Paint()
      ..color = const Color(0xFF606070)
      ..style = PaintingStyle.fill;
    for (final offset in [
      Offset(cx - 80, cy - 40),
      Offset(cx + 75, cy - 50),
      Offset(cx - 50, cy - 80),
      Offset(cx + 55, cy - 75),
      Offset(cx - 90, cy + 10),
      Offset(cx + 90, cy),
    ]) {
      canvas.drawCircle(offset, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}