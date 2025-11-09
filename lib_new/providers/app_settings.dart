import 'package:flutter_riverpod/legacy.dart';
import '../types/dtos/app_settings.dart';

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(AppSettings());

  void setAppSettings(AppSettings appSettings) {
    state = appSettings;
  }

  void resetSettings() {
    state = AppSettings();
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>(
        (ref) => AppSettingsNotifier());
