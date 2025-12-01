import 'package:flutter_riverpod/legacy.dart';

import '../types/dtos/subscription.dart';

class SubscriptionNotifier extends StateNotifier<List<Subscription>> {
  SubscriptionNotifier() : super([]);

  Future<void> addSubscription(Subscription subscription) async {
    state = [...state, subscription];
  }

  Future<void> removeSubscription(Subscription subscription) async {
    state = state.where((c) => c != subscription).toList();
  }

  void clearSubscriptions() {
    state = [];
  }

  void setSubscriptions(List<Subscription> subscription) {
    state = subscription;
  }
}

final subscriptionsProvider =
    StateNotifierProvider<SubscriptionNotifier, List<Subscription>>(
        (ref) => SubscriptionNotifier());
