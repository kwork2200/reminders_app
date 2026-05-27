import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAdsEnabled = true;
  bool _isInitialized = false;
  StreamSubscription<DocumentSnapshot>? _adsConfigSubscription;

  bool get isAdsEnabled => _isAdsEnabled;
  bool get isInitialized => _isInitialized;

  // Callback to notify when ads config changes
  Function(bool)? onAdsConfigChanged;

  Future<void> fetchAdsConfig() async {
    try {
      print('🔥 Firebase: Fetching ads config from reminders_app_config/reminders_ads_config');
      final docSnapshot = await _firestore
          .collection('reminders_app_config')
          .doc('reminders_ads_config')
          .get(const GetOptions(source: Source.server));

      print('🔥 Firebase: Document exists: ${docSnapshot.exists}');
      
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          print('Firebase: Available keys: ${data.keys.toList()}');
          bool found = false;
          for (String key in data.keys) {
            if (key.trim() == 'isAdsEnabled') {
              _isAdsEnabled = data[key] as bool;
              print('Firebase: isAdsEnabled field found: $_isAdsEnabled (key: "$key")');
              found = true;
              break;
            }
          }
          
          if (!found) {
            print('Firebase: isAdsEnabled field not found, defaulting to true');
            _isAdsEnabled = true;
          }
        } else {
          print('Firebase: Data is null, defaulting to true');
          _isAdsEnabled = true;
        }
        
        _isInitialized = true;
        print('Firebase: Ads config fetched - isAdsEnabled: $_isAdsEnabled');
      } else {
        print('Firebase: Document does not exist, creating default');
        await _firestore.collection('reminders_app_config').doc('reminders_ads_config').set({
          'isAdsEnabled': true,
        });
        _isAdsEnabled = true;
        _isInitialized = true;
        print('Firebase: Created default ads config - isAdsEnabled: true');
      }
    } catch (e) {
      print('Firebase: Error fetching ads config: $e');
      _isAdsEnabled = true;
      _isInitialized = true;
    }
  }

  void startAdsConfigListener() {
    _adsConfigSubscription?.cancel();
    
    print('Firebase: Starting real-time ads config listener');
    _adsConfigSubscription = _firestore
        .collection('reminders_app_config')
        .doc('reminders_ads_config')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      print('Firebase: Real-time update received');
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        print('Firebase: Real-time data: $data');
        
        if (data != null) {
          bool found = false;
          for (String key in data.keys) {
            if (key.trim() == 'isAdsEnabled') {
              final newAdsEnabled = data[key] as bool;
              if (_isAdsEnabled != newAdsEnabled) {
                _isAdsEnabled = newAdsEnabled;
                onAdsConfigChanged?.call(_isAdsEnabled);
              } else {
                print('Firebase: Ads config unchanged, no update needed');
              }
              found = true;
              break;
            }
          }
        } else {
          print('Firebase: Real-time data is null');
        }
      } else {
        print('Firebase: Real-time update: document does not exist');
      }
    }, onError: (error) {
      print('Firebase: Error in ads config listener: $error');
    });
  }

  void stopAdsConfigListener() {
    _adsConfigSubscription?.cancel();
    _adsConfigSubscription = null;
    print('Firebase: Stopped ads config listener');
  }

  void dispose() {
    stopAdsConfigListener();
  }

  Stream<DocumentSnapshot> listenToAdsConfig() {
    return _firestore.collection('reminders_app_config').doc('reminders_ads_config').snapshots();
  }
}
