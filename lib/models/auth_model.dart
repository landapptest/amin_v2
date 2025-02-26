import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//firebase auth 관련 로직들
class AuthModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password
      );
      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      return userCredential;
    }
    on FirebaseAuthException catch(e) {
      debugPrint("Error: signUpWithEmailandPassword: ${e}");
      throw Exception(e);
    }
  }
}