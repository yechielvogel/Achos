import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/repository.dart';
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
