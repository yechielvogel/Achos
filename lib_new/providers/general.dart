import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/repository.dart';
import '../screens/home/home.dart';
import '../types/dtos/app_style.dart';
import 'user.dart';

final errorProvider = StateProvider<String?>((ref) => null);

final repositoryProvider = Provider<Repository>((ref) {
  return Repository();
});

// is admin provider
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  return user.roll?.name == 'admin';
});

// general loading provider
final generalLoadingProvider = StateProvider<bool>((ref) => false);

final dateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final currentStartDateProvider = StateProvider<DateTime>((ref) {
  final date = ref.watch(dateProvider);
  return DateTime(date.year, date.month, date.day);
});

final currentEndDateProvider = StateProvider<DateTime>((ref) {
  final date = ref.watch(dateProvider);
  return DateTime(date.year, date.month, date.day);
});

final currentZoomLevelProvider =
    StateProvider<ZoomLevel>((ref) => ZoomLevel.day);

final styleProvider = Provider<AppStyle>((ref) => AppStyle.defaultStyle());
