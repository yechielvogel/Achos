import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../shared/helpers/error_handler.dart';
import '../types/dtos/app_style.dart';
import '../types/dtos/hachlata.dart';
import '../types/dtos/user.dart' as achosUser;

class Repository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // creates everything for a user in supabase
  Future<void> createUser(achosUser.User user, int schoolId) async {
    try {
      // Convert User object to JSON and add schoolId
      final userData = user.toJson();
      userData['school_id'] = schoolId;

      // Insert the user data into the 'user' table
      final response = await _supabaseClient.from('user').insert(userData);

      if (response.error != null) {
        throw Exception('Failed to create user: ${response.error!.message}');
      }
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // get user profile from supabase
  Future<achosUser.User> getUserInfo(String firebaseUserId) async {
    try {
      final response = await _supabaseClient
          .from('user')
          .select('*, school(*), contact!contact_user_fkey(*)')
          .eq('firebase_uid', firebaseUserId)
          .maybeSingle();

      if (response == null) {
        throw Exception('User not found for firebaseUserId: $firebaseUserId');
      }

      return achosUser.User.fromJson(response);
    } catch (e, stackTrace) {
      ErrorHandler.setError(e);
      print(stackTrace);
      rethrow;
    }
  }

  // approves a user in supabase
  Future<void> approveUser() async {}

  // creates a subscription for a hachlata
  Future<void> createSubscription(
      DateTime dateStart, DateTime dateEnd, int hachlataId) async {}

  // completes a hachlata
  Future<void> completeHachlata(int hachlataId, int subscriptionId) async {}

  // gets user hachlatas for the user for the given day
  Future<List<Hachlata>> getHachlatas(DateTime date) async {
    return [];
  }

  // gets list of schools (for logging in and signing up)
  Future<List<Map<String, dynamic>>> getSchools() async {
    return [];
  }

  // gets the app style
  Future<AppStyle> getSchoolStyle({bool refreshFromSupabase = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (!refreshFromSupabase) {
      // final cached = prefs.getString('app_style_$schoolId');
      final cached = prefs.getString('app_style_${1}}');
      if (cached != null) {
        try {
          return AppStyle.fromMap(jsonDecode(cached));
        } catch (_) {}
      }
    }

    // Fetch from Supabase
    final response = await _supabaseClient
        .from('app_style')
        .select()
        // .eq('school_id', schoolId)
        .eq('school', 1)
        .maybeSingle();

    if (response == null) {
      final defaultStyle = AppStyle.defaultStyle();
      // await prefs.setString('app_style_$schoolId', jsonEncode(defaultStyle.toMap()));
      await prefs.setString(
          'app_style_${1}}', jsonEncode(defaultStyle.toMap()));

      return defaultStyle;
    }

    final style = AppStyle.fromMap(response);

    // await prefs.setString('app_style_$schoolId', jsonEncode(style.toMap()));
    await prefs.setString('app_style_${1}', jsonEncode(style.toMap()));

    return style;
  }
}
