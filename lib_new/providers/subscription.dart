import 'package:flutter_riverpod/legacy.dart';

import '../types/dtos/subscription.dart';

class SubscriptionNotifier extends StateNotifier<List<Subscription>> {
  SubscriptionNotifier() : super([]);

  Future<void> addSubscription(Subscription subscription) async {
    if (!state.contains(subscription)) {
      state = [...state, subscription];
    }
  }

  Future<void> removeSubscription(Subscription subscription) async {
    state = state.where((c) => c != subscription).toList();
  }

  void clearSubscriptions() {
    state = [];
  }

  Future<void> setSubscriptions(List<Subscription> subscription) async {
    state = subscription;
  }
}

final subscriptionsProvider =
    StateNotifierProvider<SubscriptionNotifier, List<Subscription>>(
        (ref) => SubscriptionNotifier());
