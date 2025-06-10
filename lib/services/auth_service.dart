// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? currentUser = _auth.currentUser;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      currentUser = result.user;
      notifyListeners();
      return currentUser;
    } catch (e) {
      debugPrint("Sign In Error: $e");
      return null;
    }
  }

  Future<User?> signUp(String email, String password, String username, String domain, String stream, String currentStage) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      currentUser = result.user;

      // Save extra data to Firestore
      FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).set({
        "username": username,
        "email": email,
        "domain": domain,
        "stream": stream,
        "current_stage": currentStage,
        "enrolled_roadmaps": [],
        "created_at": DateTime.now(),
      });

      notifyListeners();
      return currentUser;
    } catch (e) {
      debugPrint("Sign Up Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}