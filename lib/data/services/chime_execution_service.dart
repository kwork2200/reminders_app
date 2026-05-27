import 'package:flutter/material.dart';
import '../models/chime_model.dart';
import 'vibration_service.dart';
import 'sound_service.dart';

class ChimeExecutionService {
  static Future<void> executeChime(Chime chime) async {
    try {
      debugPrint('Executing chime: ${chime.name}');
      
      // Play sound if enabled
      if (chime.soundEnabled && chime.chimeSound.isNotEmpty) {
        debugPrint('Playing chime sound: ${chime.chimeSound}');
        await SoundService.playSound(chime.chimeSound);
      }
      
      // Execute vibration if enabled and not "None"
      if (chime.soundEnabled && chime.vibration != 'None') {
        debugPrint('Triggering vibration pattern: ${chime.vibration}');
        await VibrationService.vibrate(chime.vibration);
      }
      
      debugPrint('Chime execution completed');
    } catch (e) {
      debugPrint('Error executing chime: $e');
    }
  }
  
  // Method to test a chime (for manual testing)
  static Future<void> testChime(Chime chime) async {
    await executeChime(chime);
  }
  
  // Method to test just vibration pattern
  static Future<void> testVibrationPattern(String pattern) async {
    await VibrationService.vibrate(pattern);
  }
  
  // Method to test just sound
  static Future<void> testSound(String soundName) async {
    await SoundService.playSound(soundName);
  }
}
