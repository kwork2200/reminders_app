import 'package:vibration/vibration.dart';

class VibrationService {
  static Future<void> vibrate(String pattern) async {
    if (pattern == 'None') return;
    
    // Check if vibration is supported
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator != true) return;
    
    switch (pattern) {
      case 'Chime Pattern':
        await _chimePattern();
        break;
      case 'Casio Style':
        await _casioStyle();
        break;
      case 'Single short':
        await _singleShort();
        break;
      case 'Double short':
        await _doubleShort();
        break;
      case 'Single long':
        await _singleLong();
        break;
      case 'Double long':
        await _doubleLong();
        break;
      default:
        await _singleShort();
    }
  }
  
  static Future<void> _chimePattern() async {
    // A gentle chime pattern: short-short-long pause
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 200);
  }
  
  static Future<void> _casioStyle() async {
    // Classic casio watch style: double beep pattern
    await Vibration.vibrate(duration: 80);
    await Future.delayed(const Duration(milliseconds: 80));
    await Vibration.vibrate(duration: 80);
    await Future.delayed(const Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 80);
    await Future.delayed(const Duration(milliseconds: 80));
    await Vibration.vibrate(duration: 80);
  }
  
  static Future<void> _singleShort() async {
    // Single short vibration
    await Vibration.vibrate(duration: 100);
  }
  
  static Future<void> _doubleShort() async {
    // Two short vibrations with small gap
    await Vibration.vibrate(duration: 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await Vibration.vibrate(duration: 100);
  }
  
  static Future<void> _singleLong() async {
    // Single long vibration
    await Vibration.vibrate(duration: 500);
  }
  
  static Future<void> _doubleLong() async {
    // Two long vibrations with gap
    await Vibration.vibrate(duration: 500);
    await Future.delayed(const Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 500);
  }
  
  // Method to test if vibration is available
  static Future<bool> isVibrationSupported() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    return hasVibrator ?? false;
  }
}
