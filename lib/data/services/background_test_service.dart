import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'background_service.dart';

class BackgroundTestService {
  static Future<void> testBackgroundService() async {
    debugPrint('🧪 Testing Background Service...');
    
    // Check if service is running
    bool isRunning = await BackgroundService().isServiceRunning();
    debugPrint('📊 Service Running: $isRunning');
    
    if (!isRunning) {
      debugPrint('🚀 Starting background service...');
      await BackgroundService().startService();
      
      // Check again after starting
      isRunning = await BackgroundService().isServiceRunning();
      debugPrint('📊 Service Running After Start: $isRunning');
    }
    
    // Update notification to show service is active
    BackgroundService().updateNotification(
      title: '🔔 Chime Test Active',
      content: 'Testing background alarms...',
    );
    
    debugPrint('✅ Background service test completed');
  }
  
  static Future<void> showServiceStatus() async {
    bool isRunning = await BackgroundService().isServiceRunning();
    debugPrint('🔍 Background Service Status: ${isRunning ? "RUNNING" : "STOPPED"}');
    
    final service = FlutterBackgroundService();
    debugPrint('🔍 Service Instance: ${service.hashCode}');
  }
}
