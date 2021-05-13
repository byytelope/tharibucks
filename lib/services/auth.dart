import 'package:firebase_auth/firebase_auth.dart';

import 'package:tharibucks/models/user.dart';
import 'package:tharibucks/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  String getCurrentUserUid() {
    return _auth.currentUser.uid;
  }

  Future signInWithEmailPass({String email, String password}) async {
    AppUser user;
    Map status;

    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = _userFromFirebaseUser(res.user);
    } catch (e) {
      print('Exception @signIn: $e');
      String errCode = e.code;
      status = {
        'errType': errCode.contains('email') || errCode.contains('user')
            ? 'email'
            : errCode.contains('password')
                ? 'password'
                : 'general',
        'errMsg': e.message,
      };
    }
    return [user, status];
  }

  Future registerWithEmailPass({String email, String password}) async {
    AppUser user;
    Map status;

    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = _userFromFirebaseUser(res.user);
      await DatabaseService(uid: user.uid)
          .updateUserData(name: null, sugars: null, strength: 100);
    } catch (e) {
      print('Exception @registerAccount: $e');
      String errCode = e.code;
      status = {
        'errType': errCode.contains('email') || errCode.contains('user')
            ? 'email'
            : errCode.contains('password')
                ? 'password'
                : 'general',
        'errMsg': e.message,
      };
    }
    return [user, status];
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
