import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  User? get user => _user;
  bool _initialized = false;
  
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;
  
  // TAMBAHKAN SETTER INI
  set userData(Map<String, dynamic>? value) {
    _userData = value;
    notifyListeners();
  }

  AuthProvider() {
    _auth.authStateChanges().listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });
    _initGoogleSignIn();
  }

  Future<void> _initGoogleSignIn() async {
    if (_initialized) return;
    _initialized = true;
    await _googleSignIn.initialize();
    _googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        debugPrint("Error: ID Token tidak ditemukan.");
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);

      final String baseUrl = "http://192.168.0.13/tubes_api";

      debugPrint("Mencoba kirim ke PHP...");
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {"id_token": idToken},
      );

      debugPrint("Status HTTP: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final responseData = json.decode(response.body);
      
      if (responseData["status"] == "success") {
        _userData = responseData["data"];
        debugPrint("=== USER DATA SAVED ===");
        debugPrint("User ID: ${_userData?['id']}");
        debugPrint("User Name: ${_userData?['nama']}");
        debugPrint("User Email: ${_userData?['email']}");
        debugPrint("Full User Data: $_userData");
        notifyListeners();
      } else {
        debugPrint("Error dari server: ${responseData["message"]}");
        _userData = null;
      }

    } catch (e) {
      debugPrint("Error login: $e");
      _userData = null;
    }
  }

  Future<bool> registerWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        debugPrint("Error: ID Token tidak ditemukan.");
        return false;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);

      final String baseUrl = "http://192.168.0.13/tubes_api";
      
      debugPrint("Mengirim request register ke PHP...");
      final response = await http.post(
        Uri.parse("$baseUrl/register_google.php"),
        body: {"id_token": idToken},
      );

      debugPrint("Status HTTP: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final responseData = json.decode(response.body);
      
      if (responseData["status"] == "success") {
        _userData = responseData["data"];
        debugPrint("User ID: ${_userData?['id']}");
        notifyListeners();
        return true;
      } else if (responseData["status"] == "exists") {
        _userData = responseData["data"];
        debugPrint("User sudah ada, ID: ${_userData?['id']}");
        notifyListeners();
        return true;
      } else {
        debugPrint("Error register: ${responseData['message']}");
        _userData = null;
        return false;
      }

    } catch (e) {
      debugPrint("Error register with Google: $e");
      _userData = null;
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _userData = null;
    notifyListeners();
  }
}