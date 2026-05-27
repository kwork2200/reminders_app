import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_chime_controller.dart';

class AddChimeView extends GetView<AddChimeController> {
  const AddChimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? const Color(0xFF0E0E0E) : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? const Color(0xFF0E0E0E) : Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Get.isDarkMode ? Colors.white : Colors.black87, size: 28),
          onPressed: controller.goBack,
        ),
        title: Obx(
          () => Text(
            controller.isEditMode.value ? 'Edit Chime' : 'Add Chime',
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: ElevatedButton(
              onPressed: controller.saveChime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text(
                'Save',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Chime Name'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.nameController,
                      focusNode: controller.nameFocus,
                      style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Custom Chime',
                        hintStyle: TextStyle(color: Get.isDarkMode ? const Color(0xFF8E8E93) : Colors.black38),
                        filled: true,
                        fillColor: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Get.isDarkMode ? const Color(0xFF8E8E93) : Colors.grey.shade400,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Get.isDarkMode ? const Color(0xFFFF3B30) : const Color(0xFF1976D2),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Chime Time'),
                    const SizedBox(height: 12),
                    _buildTimePicker(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionLabel('Chime Days'),
                        OutlinedButton(
                          onPressed: controller.toggleAllDays,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                            side: BorderSide(color: Get.isDarkMode ? Colors.white54 : Colors.black38),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'All',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (i) => _buildDayButton(i)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.graphic_eq,
                          color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sound',
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => Switch(
                            value: controller.soundEnabled.value,
                            onChanged: controller.toggleSound,
                            activeColor: Colors.white,
                            activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                            inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
                            inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => controller.soundEnabled.value
                          ? Column(
                              children: [
                                Divider(
                                  color: Get.isDarkMode ? const Color(0xFF2C2C2E) : Colors.grey.shade300,
                                  height: 1,
                                ),
                                const SizedBox(height: 12),
                                Obx(
                                  () => _buildSettingsRow(
                                    icon: Icons.music_note,
                                    label: 'Chime Sound',
                                    value: controller.selectedChimeSound.value,
                                    onTap: controller.selectChimeSound,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  color: Get.isDarkMode ? const Color(0xFF2C2C2E) : Colors.grey.shade300,
                                  height: 1,
                                ),
                                const SizedBox(height: 12),
                                Obx(
                                  () => _buildSettingsRow(
                                    icon: Icons.vibration,
                                    label: 'Vibration',
                                    value: controller.selectedVibration.value,
                                    onTap: controller.selectVibration,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  color: Get.isDarkMode ? const Color(0xFF2C2C2E) : Colors.grey.shade300,
                                  height: 1,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.record_voice_over_outlined,
                                      color: Get.isDarkMode ? Colors.white54 : Colors.black38,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Speak the Time',
                                      style: TextStyle(
                                        color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Obx(
                                      () => Switch(
                                        value: controller.speakTime.value,
                                        onChanged: controller.toggleSpeakTime,
                                        activeColor: Colors.white,
                                        activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                                        inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
                                        inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => controller.speakTime.value
                                      ? Column(
                                          children: [
                                            const SizedBox(height: 16),
                                            Obx(
                                              () => _buildSettingsRow(
                                                icon: Icons.timer,
                                                label: 'Announce before chime',
                                                value: controller
                                                    .selectedAnnounceTime
                                                    .value,
                                                onTap: controller
                                                    .selectAnnounceTime,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            const Divider(
                                              color: Color(0xFF2C2C2E),
                                              height: 1,
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.mic,
                                                  color: Colors.white54,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Voice Note',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Obx(
                                                  () => Switch(
                                                    value: controller
                                                        .voiceNote
                                                        .value,
                                                    onChanged: controller
                                                        .toggleVoiceNote,
                                                    activeColor: Colors.white,
                                                    activeTrackColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                                                    inactiveThumbColor: Get.isDarkMode ? Colors.white54 : Colors.black54,
                                                    inactiveTrackColor: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () => controller.isEditMode.value
                    ? SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8,
                            top: 10,
                            bottom: 10,
                          ),
                          child: ElevatedButton(
                            onPressed: controller.deleteChime,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Get.isDarkMode ? Colors.transparent : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Get.isDarkMode ? Colors.white : Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTimePicker() {
    final hours = List.generate(12, (i) => i + 1);
    final minutes = List.generate(60, (i) => i);
    final periods = ['am', 'pm'];

    return SizedBox(
      height: 150,
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _buildScrollColumn(
                items: hours.map((h) => h.toString()).toList(),
                selectedValue: controller.selectedHour.value.toString(),
                onChanged: controller.updateHour,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              ':',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => _buildScrollColumn(
                items: minutes
                    .map((m) => m.toString().padLeft(2, '0'))
                    .toList(),
                selectedValue: controller.selectedMinute.value
                    .toString()
                    .padLeft(2, '0'),
                onChanged: controller.updateMinute,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => _buildScrollColumn(
                items: periods,
                selectedValue: controller.isPM.value ? 'pm' : 'am',
                onChanged: controller.updatePeriod,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollColumn({
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    final selectedIndex = items.indexOf(selectedValue);
    final controller = FixedExtentScrollController(
      initialItem: selectedIndex < 0 ? 0 : selectedIndex,
    );

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      perspective: 0.003,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) => onChanged(items[index]),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          final isSelected = items[index] == selectedValue;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  items[index],
                  style: TextStyle(
                    color: isSelected 
                        ? (Get.isDarkMode ? Colors.white : Colors.black87)
                        : (Get.isDarkMode ? Colors.white38 : Colors.black38),
                    fontSize: isSelected ? 22 : 17,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    height: 2,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayButton(int dayIndex) {
    return Obx(() {
      final isSelected = controller.selectedDays.contains(dayIndex);
      return GestureDetector(
        onTap: () => controller.toggleDay(dayIndex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected 
                ? (Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.dayLabels[dayIndex],
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white
                      : (Get.isDarkMode ? Colors.white38 : Colors.black38),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '-',
                style: TextStyle(
                  color: isSelected 
                      ? Colors.white70
                      : (Get.isDarkMode ? Colors.white24 : Colors.black12),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Get.isDarkMode ? Colors.white54 : Colors.black38, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54, fontSize: 15),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(color: Get.isDarkMode ? Colors.white38 : Colors.black38, fontSize: 14),
          ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right, color: Get.isDarkMode ? Colors.white24 : Colors.black12, size: 18),
        ],
      ),
    );
  }
}
