import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/repository.dart';

final errorProvider = StateProvider<String?>((ref) => null);

final repositoryProvider = Provider<Repository>((ref) {
  return Repository();
});
