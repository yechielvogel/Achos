import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tzivos_hashem_milwaukee/shared/globals.dart';
import '../../api/repository.dart';
import '../../providers/general.dart';
import '../../providers/user.dart';
import '../../types/dtos/contact.dart';
import '../../types/dtos/roll.dart';
import '../../types/dtos/school.dart';
import '../../types/dtos/user.dart' as achosUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Repository repository = Repository();

  achosUser.User? _userFromFirebaseUser(
    User? user,
  ) {
    return user != null
        ? achosUser.User(
            firebaseUid: user.uid,
            username: (user.displayName != null && user.displayName!.isNotEmpty)
                ? user.displayName
                : displayusernameinaccount,
            // by default always false
            isActive: false)
        : null;
  }

  Stream<achosUser.User?> get user {
    print('state changed');
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(
      String email, String password, WidgetRef ref) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      // load the user from supabase
      if (user != null) {
        try {
          final localUser = await Repository().getUserInfo(user.uid);
          await ref.read(userProvider.notifier).setUser(localUser);
          ref.watch(generalLoadingProvider.notifier).state = false;
          print("Local user loaded: ${localUser.contact?.firstName}");
        } catch (e, stack) {
          print('Error fetching local user: $e');
          print(stack);
        }
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String firstName, String lastName, int schoolId, WidgetRef ref) async {
    try {
      int userId = await repository.createUser(
        achosUser.User(
            // firebaseUid: user.uid,
            isActive: false,
            school: School(
              id: schoolId,
            ),
            contact: Contact(
              email: email,
              firstName: firstName,
              lastName: lastName,
            ),
            roll: Roll(
              id: 2,
            )),
      );

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      ref.watch(generalLoadingProvider.notifier).state = false;
      // now that we have firebase id update the user in supabase with firebaseId
      await repository.updateUserWithFirebaseId(userId, user!.uid);
      await user!.updateDisplayName(firstName);
      await user.reload();

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut(WidgetRef ref) async {
    try {
      ref.read(userProvider.notifier).clearUser();
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // delete account
  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      // await deleteAllHachlata();
    } on FirebaseAuthException catch (e) {
      print(e.toString());

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {}
  }
}
