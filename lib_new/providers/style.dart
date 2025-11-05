import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/repository.dart';
import '../types/dtos/app_style.dart';

final appStyleProvider =
    StateNotifierProvider<AppStyleNotifier, AppStyle>((ref) {
  return AppStyleNotifier(ref);
});

class AppStyleNotifier extends StateNotifier<AppStyle> {
  final Ref ref;
  AppStyleNotifier(this.ref) : super(AppStyle.defaultStyle());

  Future<void> loadStyle({bool refresh = false}) async {
    Repository repo = Repository();
    final style = await repo.getSchoolStyle(refreshFromSupabase: refresh);
    state = style;
  }
}
