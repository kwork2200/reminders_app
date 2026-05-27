import 'package:flutter/material.dart';
import 'storage_service.dart';
import '../models/chime_model.dart';

class StorageTest {
  static Future<void> testStorage() async {
    print('=== Testing Storage Service ===');
    
    try {
      // Initialize storage
      final storageService = StorageService();
      await storageService.init();
      
      // Clear existing chimes for clean test
      await storageService.clearChimes();
      print('Cleared existing chimes');
      
      // Create a test chime
      final testChime = Chime(
        id: 'test-123',
        name: 'Test Chime',
        hour: 6,
        minute: 30,
        isPM: true,
        days: {0, 1, 2, 3, 4, 5, 6},
        soundEnabled: true,
        chimeSound: 'Happy Ending',
        vibration: 'None',
        speakTime: false,
        announceBeforeChime: false,
        announceTime: '5 sec',
        voiceNote: false,
        isEnabled: true,
      );
      
      // Save the test chime
      await storageService.addChime(testChime);
      print('Test chime saved');
      
      // Retrieve and verify
      final retrievedChimes = storageService.getChimes();
      print('Retrieved ${retrievedChimes.length} chimes');
      
      if (retrievedChimes.isNotEmpty) {
        final retrieved = retrievedChimes.first;
        print('Retrieved chime: ${retrieved.name} - ${retrieved.formattedTime}');
        print('Test PASSED: Storage is working correctly');
      } else {
        print('Test FAILED: No chimes retrieved');
      }
      
    } catch (e, stackTrace) {
      print('Test ERROR: $e');
      print('Stack trace: $stackTrace');
    }
    
    print('=== End Storage Test ===');
  }
}
