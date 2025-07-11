import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // API Key Management
  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: AppConstants.apiKeyStorageKey, value: apiKey);
  }

  static Future<String?> getApiKey() async {
    return await _storage.read(key: AppConstants.apiKeyStorageKey);
  }

  static Future<void> deleteApiKey() async {
    await _storage.delete(key: AppConstants.apiKeyStorageKey);
  }

  // Language Management
  static Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: AppConstants.languageStorageKey, value: languageCode);
  }

  static Future<String?> getLanguage() async {
    return await _storage.read(key: AppConstants.languageStorageKey);
  }

  // Theme Management
  static Future<void> saveTheme(String themeMode) async {
    await _storage.write(key: AppConstants.themeStorageKey, value: themeMode);
  }

  static Future<String?> getTheme() async {
    return await _storage.read(key: AppConstants.themeStorageKey);
  }

  // Clear All Data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if API key exists
  static Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }
}