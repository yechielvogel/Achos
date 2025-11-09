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
  Future<int> createUser(achosUser.User user) async {
    try {
      final contactData = user.contact!.toJson();

      final contactResponse = await _supabaseClient
          .from('contact')
          .insert(contactData)
          .select()
          .single();

      final contactId = contactResponse['id'];

      final userData = user.toJson();

      userData['contact'] = contactId;
      userData['school'] = user.school?.id;
      userData['roll'] = user.roll?.id;

      final userResponse =
          await _supabaseClient.from('user').insert(userData).select().single();

      final userId = userResponse['id'];
      print('Created user $userId linked to contact $contactId');
      return userId;
    } catch (e) {
      print('Error creating user and contact: $e');
      rethrow;
    }
  }

  // update user with firebaseId
  Future<String> updateUserWithFirebaseId(int userId, String firebaseId) async {
    try {
      final user = await _supabaseClient
          .from('user')
          .update({'firebase_uid': firebaseId})
          .eq('id', userId)
          .select()
          .single();

      return user['firebase_uid'];
    } catch (e) {
      print('Error updating user with firebaseId: $e');
      rethrow;
    }
  }

  // get user profile from supabase
  Future<achosUser.User> getUserInfo(String firebaseUserId) async {
    // this is for testing only
    // final AuthService _auth = AuthService();
    // await _auth.signOut();
    try {
      final response = await _supabaseClient
          .from('user')
          .select('*, school(*), contact(*), roll(*) ')
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

  Future<List<achosUser.User>> getAllSchoolUsers(int schoolId) async {
    try {
      final response = await _supabaseClient
          .from('user')
          .select('*, roll(*), contact!contact_user_fkey(*)')
          .eq('school', schoolId);

      // In some SDK versions, response may be a PostgrestResponse
      // If so, replace with: final data = response.data as List<dynamic>;
      final data = response as List<dynamic>;

      if (data.isEmpty) {
        throw Exception('No users found for schoolId: $schoolId');
      }

      return data
          .map((user) => achosUser.User.fromJson(user as Map<String, dynamic>))
          .toList();
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
