import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

class FeedbackView extends GetView<SettingsController> {
  const FeedbackView({Key? key}) : super(key: key);

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
          'Feedback',
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
              'We Value Your Feedback',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us improve Hourly Chime by sharing your thoughts',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 32.h),
            
            // Overall Rating Section
            _buildSectionTitle('Overall Rating'),
            SizedBox(height: 12.h),
            _buildRatingSection(),
            SizedBox(height: 24.h),
            
            // Feedback Type Section
            _buildSectionTitle('Feedback Type'),
            SizedBox(height: 12.h),
            _buildFeedbackTypeSection(),
            SizedBox(height: 24.h),
            
            // Detailed Feedback Section
            _buildSectionTitle('Detailed Feedback'),
            SizedBox(height: 12.h),
            _buildFeedbackInput(),
            SizedBox(height: 32.h),
            
            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black87,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'How would you rate your experience?',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => controller.selectedRating.value = index + 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Icon(
                    index < controller.selectedRating.value 
                        ? Icons.star 
                        : Icons.star_border,
                    color: const Color(0xFFFFD700),
                    size: 32.sp,
                  ),
                ),
              );
            }),
          )),
          SizedBox(height: 12.h),
          Obx(() => Text(
            controller.selectedRating.value == 0
                ? 'Tap to rate'
                : '${controller.selectedRating.value} star${controller.selectedRating.value > 1 ? 's' : ''}',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white54 : Colors.black38,
              fontSize: 12.sp,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSection() {
    final feedbackTypes = [
      'Bug Report',
      'Feature Request',
      'General Feedback',
      'UI/UX Issue',
      'Performance Issue',
      'Other'
    ];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedFeedbackType.value.isEmpty 
              ? null 
              : controller.selectedFeedbackType.value,
          hint: Text(
            'Select feedback type',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white54 : Colors.black38,
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          dropdownColor: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Get.isDarkMode ? Colors.white54 : Colors.black38,
          ),
          items: feedbackTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedFeedbackType.value = newValue;
            }
          },
        ),
      )),
    );
  }

  Widget _buildFeedbackInput() {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller.feedbackController,
        maxLines: 6,
        style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Please describe your feedback in detail...\n\n• What were you trying to do?\n• What happened instead?\n• Any additional information that might help us?',
          hintStyle: TextStyle(
            color: Get.isDarkMode ? Colors.white38 : Colors.black38,
            fontSize: 14,
            height: 1.4,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.canSubmitFeedback() ? controller.submitFeedback : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          disabledBackgroundColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
        ),
        child: Text(
          'Submit Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      )),
    );
  }
}
