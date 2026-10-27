import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../ads/ad_on_back_wrapper.dart';
import '../../ads/hybrid_banner_ad_widget.dart';
import '../../ads/hybrid_native_ad_widget.dart';
import 'settings_controller.dart';

class QuietHoursView extends GetView<SettingsController> {
  const QuietHoursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdOnBackWrapper(
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xFF0E0F12) : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? const Color(0xFF0E0F12) : Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Get.isDarkMode ? Colors.white : Colors.black87, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Quiet Hours',
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
              'Configure Quiet Hours',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set a time range when chimes should be silenced',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 32.h),

            // Enable Quiet Hours Toggle
            _buildToggleSection(),
            SizedBox(height: 20.h),

            const HybridNativeAdWidget(),
            SizedBox(height: 20.h),

            // Time Selection Section
            Obx(() => controller.quietHoursEnabled.value 
                ? _buildTimeSelectionSection() 
                : const SizedBox.shrink()),

            SizedBox(height: 10.h),
            Obx(() => controller.quietHoursEnabled.value
                ? HybridNativeAdWidget()
                : const SizedBox.shrink()),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: const HybridBannerAdWidget(),
      ),
    );
  }

  Widget _buildToggleSection() {
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
      child: Row(
        children: [
          Icon(
            Icons.do_not_disturb_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.black87,
            size: 24,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Quiet Hours',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Silence chimes during specified hours',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: controller.quietHoursEnabled.value,
            onChanged: controller.toggleQuietHours,
            activeColor: Colors.white,
            activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
            inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
            inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
          )),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionSection() {
    return Column(
      children: [
        // Start Time
        _buildTimeCard(
          title: 'Start Time',
          subtitle: 'Chimes will be silenced starting from',
          hour: controller.quietHoursStartHour,
          minute: controller.quietHoursStartMinute,
          isPM: controller.quietHoursStartIsPM,
          onHourChanged: (value) => controller.quietHoursStartHour.value = value,
          onMinuteChanged: (value) => controller.quietHoursStartMinute.value = value,
          onPeriodChanged: (value) => controller.quietHoursStartIsPM.value = value,
        ),
        
        SizedBox(height: 16.h),
        
        // End Time
        _buildTimeCard(
          title: 'End Time',
          subtitle: 'Chimes will resume at',
          hour: controller.quietHoursEndHour,
          minute: controller.quietHoursEndMinute,
          isPM: controller.quietHoursEndIsPM,
          onHourChanged: (value) => controller.quietHoursEndHour.value = value,
          onMinuteChanged: (value) => controller.quietHoursEndMinute.value = value,
          onPeriodChanged: (value) => controller.quietHoursEndIsPM.value = value,
        ),
        
        SizedBox(height: 24.h),
        
        // Current Settings Display
        _buildCurrentSettingsDisplay(),
        
        SizedBox(height: 32.h),
        
        // Save Button
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String subtitle,
    required RxInt hour,
    required RxInt minute,
    required RxBool isPM,
    required Function(int) onHourChanged,
    required Function(int) onMinuteChanged,
    required Function(bool) onPeriodChanged,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Time Picker
          GestureDetector(
            onTap: () => _showTimePicker(
              hour.value,
              minute.value,
              isPM.value,
              onHourChanged,
              onMinuteChanged,
              onPeriodChanged,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    '${hour.value.toString().padLeft(2, '0')}:${minute.value.toString().padLeft(2, '0')} ${isPM.value ? 'PM' : 'AM'}',
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  Icon(
                    Icons.access_time,
                    color: Get.isDarkMode ? Colors.white54 : Colors.black54,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSettingsDisplay() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A1C22) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Current Quiet Hours',
                style: TextStyle(
                  color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() => Text(
            '${controller.quietHoursStartHour.value.toString().padLeft(2, '0')}:${controller.quietHoursStartMinute.value.toString().padLeft(2, '0')} ${controller.quietHoursStartIsPM.value ? 'PM' : 'AM'} - ${controller.quietHoursEndHour.value.toString().padLeft(2, '0')}:${controller.quietHoursEndMinute.value.toString().padLeft(2, '0')} ${controller.quietHoursEndIsPM.value ? 'PM' : 'AM'}',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.saveQuietHours(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Text(
          'Save Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showTimePicker(
    int currentHour,
    int currentMinute,
    bool currentIsPM,
    Function(int) onHourChanged,
    Function(int) onMinuteChanged,
    Function(bool) onPeriodChanged,
  ) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2)),
                    ),
                  ),
                  Text(
                    'Select Time',
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2)),
                    ),
                  ),
                ],
              ),
            ),
            
            // Time Picker
            SizedBox(
              height: 200.h,
              child: Row(
                children: [
                  // Hours
                  Expanded(
                    child: _buildTimePickerColumn(
                      items: List.generate(12, (index) => (index + 1).toString()),
                      selectedValue: currentHour == 0 ? '12' : currentHour.toString(),
                      onChanged: (index) => onHourChanged(index == 0 ? 12 : index + 1),
                    ),
                  ),
                  
                  // Colon
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Text(
                      ':',
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Minutes
                  Expanded(
                    child: _buildTimePickerColumn(
                      items: List.generate(60, (index) => index.toString().padLeft(2, '0')),
                      selectedValue: currentMinute.toString().padLeft(2, '0'),
                      onChanged: (index) => onMinuteChanged(index),
                    ),
                  ),
                  
                  // AM/PM
                  Expanded(
                    child: _buildTimePickerColumn(
                      items: ['AM', 'PM'],
                      selectedValue: currentIsPM ? 'PM' : 'AM',
                      onChanged: (index) => onPeriodChanged(index == 1),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerColumn({
    required List<String> items,
    required String selectedValue,
    required Function(int) onChanged,
  }) {
    final selectedIndex = items.indexOf(selectedValue);
    final controller = FixedExtentScrollController(
      initialItem: selectedIndex < 0 ? 0 : selectedIndex,
    );

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 40,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              items[index],
              style: TextStyle(
                color: isSelected 
                    ? (Get.isDarkMode ? Colors.white : Colors.black87)
                    : (Get.isDarkMode ? Colors.white38 : Colors.black38),
                fontSize: isSelected ? 22 : 17,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}
