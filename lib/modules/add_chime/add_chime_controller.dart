import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/chime_model.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/sound_service.dart';
import '../../data/services/vibration_service.dart';
import '../../routes/app_routes.dart';
import '../home/home_controller.dart';

class AddChimeController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  final selectedHour = 6.obs;
  final selectedMinute = 26.obs;
  final isPM = true.obs;

  final selectedDays = <int>{0, 1, 2, 4, 5, 6}.obs; // Sun Mon Tue Thu Fri Sat
  final soundEnabled = true.obs;
  final speakTime = false.obs;
  final announceBeforeChime = false.obs;
  final voiceNote = false.obs;
  final selectedChimeSound = 'Happy Ending'.obs;
  final selectedVibration = 'None'.obs;
  final selectedAnnounceTime = '5 sec'.obs;

  final List<String> dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  // Edit mode variables
  final isEditMode = false.obs;
  final editingChimeId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameFocus.addListener(() {});
    
    // Check if we're in edit mode
    final chimeId = Get.arguments as String?;
    if (chimeId != null) {
      loadChimeForEdit(chimeId);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    nameFocus.dispose();
    super.onClose();
  }

  void toggleDay(int dayIndex) {
    if (selectedDays.contains(dayIndex)) {
      selectedDays.remove(dayIndex);
    } else {
      selectedDays.add(dayIndex);
    }
  }

  void toggleAllDays() {
    if (selectedDays.length == 7) {
      selectedDays.clear();
    } else {
      selectedDays.addAll(List.generate(7, (i) => i));
    }
  }

  void updateHour(String val) {
    selectedHour.value = int.parse(val);
  }

  void updateMinute(String val) {
    selectedMinute.value = int.parse(val);
  }

  void updatePeriod(String val) {
    isPM.value = val == 'pm';
  }

  void toggleSound(bool value) {
    soundEnabled.value = value;
  }

  void toggleSpeakTime(bool value) {
    speakTime.value = value;
  }

  void toggleAnnounceBeforeChime(bool value) {
    announceBeforeChime.value = value;
  }

  void toggleVoiceNote(bool value) {
    voiceNote.value = value;
  }

  void loadChimeForEdit(String chimeId) {
    final chimes = _storageService.getChimes();
    final chime = chimes.firstWhereOrNull((c) => c.id == chimeId);
    
    if (chime != null) {
      isEditMode.value = true;
      editingChimeId.value = chimeId;
      
      // Load chime data into form
      nameController.text = chime.name;
      selectedHour.value = chime.hour;
      selectedMinute.value = chime.minute;
      isPM.value = chime.isPM;
      selectedDays.clear();
      selectedDays.addAll(chime.days);
      soundEnabled.value = chime.soundEnabled;
      selectedChimeSound.value = chime.chimeSound;
      selectedVibration.value = chime.vibration;
      speakTime.value = chime.speakTime;
      announceBeforeChime.value = chime.announceBeforeChime;
      selectedAnnounceTime.value = chime.announceTime;
      voiceNote.value = chime.voiceNote;
    }
  }

  void selectAnnounceTime() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('5 sec', style: TextStyle(color: Colors.white)),
              onTap: () {
                selectedAnnounceTime.value = '5 sec';
                Get.back();
              },
            ),
            ListTile(
              title: Text('10 sec', style: TextStyle(color: Colors.white)),
              onTap: () {
                selectedAnnounceTime.value = '10 sec';
                Get.back();
              },
            ),
            ListTile(
              title: Text('15 sec', style: TextStyle(color: Colors.white)),
              onTap: () {
                selectedAnnounceTime.value = '15 sec';
                Get.back();
              },
            ),
            ListTile(
              title: Text('30 sec', style: TextStyle(color: Colors.white)),
              onTap: () {
                selectedAnnounceTime.value = '30 sec';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void selectChimeSound() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Select Chime Sound',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF2C2C2E), height: 1),
            Expanded(
              child: ListView(
                children: SoundService.availableSounds
                    .map((sound) => _buildSoundTile(sound))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundTile(String soundName) {
    return Obx(() => ListTile(
      title: Text(
        soundName,
        style: TextStyle(
          color: selectedChimeSound.value == soundName 
            ? const Color(0xFF2979FF) 
            : Colors.white,
        ),
      ),
      trailing: selectedChimeSound.value == soundName
        ? const Icon(Icons.check, color: Color(0xFF2979FF))
        : null,
      onTap: () {
        selectedChimeSound.value = soundName;
        _testChimeSound(soundName);
        Get.back();
      },
    ));
  }

  void selectVibration() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6, // Constrain height to 60% of screen
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Select Vibration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF2C2C2E), height: 1),
            // Scrollable list of vibrations
            Expanded(
              child: ListView(
                children: [
                  _buildVibrationTile('None'),
                  _buildVibrationTile('Chime Pattern'),
                  _buildVibrationTile('Casio Style'),
                  _buildVibrationTile('Single short'),
                  _buildVibrationTile('Double short'),
                  _buildVibrationTile('Single long'),
                  _buildVibrationTile('Double long'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVibrationTile(String vibrationName) {
    return Obx(() => ListTile(
      title: Text(
        vibrationName,
        style: TextStyle(
          color: selectedVibration.value == vibrationName 
            ? const Color(0xFF2979FF) 
            : Colors.white,
        ),
      ),
      trailing: selectedVibration.value == vibrationName
        ? const Icon(Icons.check, color: Color(0xFF2979FF))
        : null,
      onTap: () {
        selectedVibration.value = vibrationName;
        if (vibrationName != 'None') {
          _testVibration(vibrationName);
        }
        Get.back();
      },
    ));
  }

  void _testVibration(String pattern) async {
    try {
      await VibrationService.vibrate(pattern);
    } catch (e) {
      print('Vibration test failed: $e');
    }
  }

  void _testChimeSound(String soundName) async {
    try {
      await SoundService.playSound(soundName);
    } catch (e) {
      print('Sound test failed: $e');
    }
  }

  void saveChime() async {
    try {
      await SoundService.stopSound();

      if (isEditMode.value) {
        final chimes = _storageService.getChimes();
        final existingChime = chimes.firstWhereOrNull((c) => c.id == editingChimeId.value);

        if (existingChime != null) {
          final updatedChime = existingChime.copyWith(
            name: nameController.text.isEmpty ? '' : nameController.text,
            hour: selectedHour.value,
            minute: selectedMinute.value,
            isPM: isPM.value,
            days: Set<int>.from(selectedDays),
            soundEnabled: soundEnabled.value,
            chimeSound: selectedChimeSound.value,
            vibration: selectedVibration.value,
            speakTime: speakTime.value,
            announceBeforeChime: announceBeforeChime.value,
            announceTime: selectedAnnounceTime.value,
            voiceNote: voiceNote.value,
          );
          await _storageService.updateChime(updatedChime);
        }
      } else {
        final chime = Chime(
          id: _uuid.v4(),
          name: nameController.text.isEmpty ? 'Custom Chime' : nameController.text,
          hour: selectedHour.value,
          minute: selectedMinute.value,
          isPM: isPM.value,
          days: Set<int>.from(selectedDays),
          soundEnabled: soundEnabled.value,
          chimeSound: selectedChimeSound.value,
          vibration: selectedVibration.value,
          speakTime: speakTime.value,
          announceBeforeChime: announceBeforeChime.value,
          announceTime: selectedAnnounceTime.value,
          voiceNote: voiceNote.value,
        );
        await _storageService.addChime(chime);
      }

      // ✅ Navigate back FIRST
      Get.back(result: true);

      // ✅ Wait for previous screen to mount, THEN show snackbar + refresh
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar('Success', 'Chime saved successfully!');

      try {
        final homeController = Get.find<HomeController>();
        homeController.shouldRefreshChimes.value = true;
      } catch (e) {
        print('HomeController not found: $e');
      }

    } catch (e) {
      print('Error saving chime: $e');
      Get.snackbar(
        'Error',
        'Failed to save chime: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void deleteChime() {
  Get.defaultDialog(
    title: 'Remove Chime',
    titleStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    middleText: 'Are you sure you want to remove this chime? This action cannot be undone.',
    middleTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
    backgroundColor: const Color(0xFF1C1C1E),
    radius: 16,
    confirm: ElevatedButton(
      onPressed: () async {
        Get.back(); // Close dialog
        try {
          await _storageService.deleteChime(editingChimeId.value);
          Get.snackbar('Success', 'Chime removed successfully!');
          
          // Trigger refresh in home controller using reactive pattern
          try {
            final homeController = Get.find<HomeController>();
            homeController.triggerRefresh();
            print('Home controller refresh triggered successfully (delete)');
          } catch (e) {
            print('Could not find home controller for delete: $e');
          }
          
          Get.offAllNamed(Routes.HOME);
        } catch (e) {
          Get.snackbar('Error', 'Failed to remove chime: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Remove', style: TextStyle(color: Colors.white)),
    ),
    cancel: OutlinedButton(
      onPressed: () => Get.back(),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
    ),
  ).then((value) {
    Get.back(result: 'refresh');
  },);
}

void goBack() {
    Get.back();
  }
}
