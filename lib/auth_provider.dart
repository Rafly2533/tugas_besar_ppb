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
  
  // Data tambahan dari backend
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

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

  // ======== LOGIN DENGAN GOOGLE ========
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        debugPrint("Error: ID Token tidak ditemukan.");
        return;
      }

      // Login ke Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);

      // Kirim token ke backend PHP
      // GANTI IP INI DENGAN IP KOMPUTER ANDA!
      final String baseUrl = "http://192.168.100.77";

      debugPrint("Mencoba kirim ke PHP...");
      final response = await http.post(
        Uri.parse("$baseUrl/tubesppb/login.php"),
        body: {"id_token": idToken},
      );

      debugPrint("Status HTTP: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final responseData = json.decode(response.body);
      
      if (responseData["status"] == "success") {
        _userData = responseData["data"];
        debugPrint("User data: ${responseData['data']}");
        debugPrint("Pesan: ${responseData["message"]}");
      } else {
        debugPrint("Error dari server: ${responseData["message"]}");
      }

    } catch (e) {
      debugPrint("Error login: $e");
    }
  }

  // ======== REGISTER DENGAN GOOGLE ========
  Future<bool> registerWithGoogle() async {
    try {
      // 1. Login dengan Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        debugPrint("Error: ID Token tidak ditemukan.");
        return false;
      }

      // 2. Login ke Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);

      // 3. Kirim token ke endpoint REGISTER
      // GANTI IP INI DENGAN IP KOMPUTER ANDA!
      final String baseUrl = "http://128.150.2.126";
      
      debugPrint("Mengirim request register ke PHP...");
      final response = await http.post(
        Uri.parse("$baseUrl/tubesppb/register_google.php"),
        body: {"id_token": idToken},
      );

      debugPrint("Status HTTP: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      final responseData = json.decode(response.body);
      
      if (responseData["status"] == "success") {
        _userData = responseData["data"];
        debugPrint("Registrasi berhasil: ${responseData['message']}");
        return true;
      } else if (responseData["status"] == "exists") {
        // User sudah ada, tapi kita anggap berhasil (tetap login)
        _userData = responseData["data"];
        debugPrint("User sudah ada: ${responseData['message']}");
        return true;
      } else {
        debugPrint("Error register: ${responseData['message']}");
        return false;
      }

    } catch (e) {
      debugPrint("Error register with Google: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _userData = null;
  }
}