import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tzivos_hashem_milwaukee/screens/authenticate/sign_in.dart';
import 'package:tzivos_hashem_milwaukee/services/database.dart';
import 'package:tzivos_hashem_milwaukee/services/database.dart';

import '/models/ueser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Ueser? _userFromFirebaseUser(
    User? user,
  ) {
    return user != null
        ? Ueser(uid: user.uid, uesname: user.displayName)
        : null;
  }

// this is for testing signing into a users account. make sure to change back.
  //     return user != null
  //       ? Ueser(uid: 'JdjVvSN9ukUYCuW6FFNZQZ6rCvE2', uesname: 'Mushka Hecht ')
  //       : null;
  // }

  Stream<Ueser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  //sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await user!.updateDisplayName(name);

      // Reload the user to get the updated information.
      await user!.reload();
      name = _auth.currentUser!.displayName;
      user = _auth.currentUser;
      // await DatabaseService(uid: user!.uid).updateUserData('yes');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }

    // delete account
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
        // await deleteAllHachlata();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print(e.toString());

      // Handle general exception
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
    } catch (e) {
      // Handle exceptions
    }
  }

  //get name
// Future<String?> getUserName(String uid) async {
//   try {
//     final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//     if (userDoc.exists) {
//       final userData = userDoc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
//       if (userData != null) {
//         return userData['name'] as String?;
//       }
//     }
//     return null; // User document not found or 'name' not present
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
}
