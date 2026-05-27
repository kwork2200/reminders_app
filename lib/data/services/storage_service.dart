import 'package:get_storage/get_storage.dart';
import '../models/chime_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final GetStorage _storage;
  static const String _chimesKey = 'chimes';

  Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  // Save all chimes
  Future<void> saveChimes(List<Chime> chimes) async {
    final List<Map<String, dynamic>> jsonList = chimes.map((chime) => chime.toJson()).toList();
    await _storage.write(_chimesKey, jsonList);
  }

  // Get all chimes
  List<Chime> getChimes() {
    final List<dynamic>? jsonList = _storage.read(_chimesKey);
    if (jsonList == null) return [];
    
    return jsonList.map((json) => Chime.fromJson(json as Map<String, dynamic>)).toList();
  }

  // Add a new chime
  Future<void> addChime(Chime chime) async {
    final chimes = getChimes();
    chimes.add(chime);
    await saveChimes(chimes);
  }

  // Update a chime
  Future<void> updateChime(Chime chime) async {
    final chimes = getChimes();
    final index = chimes.indexWhere((c) => c.id == chime.id);
    if (index != -1) {
      chimes[index] = chime;
      await saveChimes(chimes);
    }
  }

  // Delete a chime
  Future<void> deleteChime(String chimeId) async {
    final chimes = getChimes();
    chimes.removeWhere((c) => c.id == chimeId);
    await saveChimes(chimes);
  }

  // Toggle chime enabled status
  Future<void> toggleChime(String chimeId) async {
    final chimes = getChimes();
    final index = chimes.indexWhere((c) => c.id == chimeId);
    if (index != -1) {
      chimes[index] = chimes[index].copyWith(isEnabled: !chimes[index].isEnabled);
      await saveChimes(chimes);
    }
  }

  // Settings methods
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _storage.write('settings', settings);
  }

  Map<String, dynamic> getSettings() {
    return _storage.read('settings') ?? {};
  }

  // Clear all chimes
  Future<void> clearChimes() async {
    await _storage.remove(_chimesKey);
  }
}
