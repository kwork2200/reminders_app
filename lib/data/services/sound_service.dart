import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static double _volume = 1.0;
  
  static const Map<String, String> _soundFiles = {
    'Beep': 'sounds/beep.mp3',
    'Casio Tone': 'sounds/casio_tone.mp3',

    'Smooth Notification': 'sounds/36505577-notification-smooth-modern-stereo-332449.mp3',
    'Dragon Alert': 'sounds/dragon-studio-alert-444816.mp3',
    'New Notification 3': 'sounds/dragon-studio-new-notification-3-398649.mp3',
    'Phone Ringing': 'sounds/dragon-studio-phone-ringing-382734.mp3',
    'Cell Phone Double Beep': 'sounds/freesound_community-cell-phone-dbl-beep-notification-83306.mp3',
    'Pop': 'sounds/freesound_community-pop-39222.mp3',
    'Smooth Intro': 'sounds/freesound_community-smooth-intro-72591.mp3',
    'Message Alert': 'sounds/liecio-message-alert-190042.mp3',
    'Digital Alert': 'sounds/soynoviembre-short-digital-notification-alert-440353.mp3',
    'Vibration': 'sounds/universfield-cell-phone-vibration-352298.mp3',
    'Double Car Horn': 'sounds/universfield-double-car-horn-352443.mp3',
    'Notification 036': 'sounds/universfield-new-notification-036-485897.mp3',
    'Notification 040': 'sounds/universfield-new-notification-040-493469.mp3',
    'Notification 057': 'sounds/universfield-new-notification-057-494255.mp3',
    'Notification 09': 'sounds/universfield-new-notification-09-352705.mp3',
    'Thriller Ring': 'sounds/bryansantosbreton-thriller-whooshes-amp-transitions-sfx-pack-186255.mp3',
    'Light Rain': 'sounds/jayalvarez66-light-rain-smooth-11608.mp3',
  };

  static List<String> get availableSounds => _soundFiles.keys.toList();
  
  static Future<void> playSound(String soundName) async {
    try {
      debugPrint('Playing sound: $soundName');
      
      String? soundFile = _soundFiles[soundName];
      if (soundFile != null) {
        try {
          await _audioPlayer.play(AssetSource(soundFile));
          debugPrint('Playing audio file: $soundFile');
          return;
        } catch (e) {
          debugPrint('Audio file not found, playing system sound: $e');
        }
      }
      
      await _playSystemSound(soundName);
      debugPrint('Sound playback completed');
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }
  
  static Future<void> _playSystemSound(String soundName) async {
    debugPrint('🔊 Playing system sound: $soundName');

    try {
      final alertSounds = [
        'Dragon Alert',
        'Phone Ringing',
        'Thriller Ring',
        'Double Car Horn',
      ];

      final clickSounds = [
        'Beep',
        'Casio Tone',
      ];

      if (alertSounds.contains(soundName)) {
        await SystemSound.play(SystemSoundType.alert);
        debugPrint('Played system alert sound');
      } else if (clickSounds.contains(soundName)) {
        await SystemSound.play(SystemSoundType.click);
        debugPrint('Played system click sound');
      } else {
        await SystemSound.play(SystemSoundType.click);
        debugPrint('Played system click sound for notification');
      }
    } catch (e) {
      debugPrint('Error playing system sound: $e');
    }
  }

  static void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    _audioPlayer.setVolume(_volume);
    debugPrint('Sound volume set to: ${(_volume * 100).toInt()}%');
  }

  static Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
      debugPrint('Sound stopped');
    } catch (e) {
      debugPrint('Error stopping sound: $e');
    }
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}
