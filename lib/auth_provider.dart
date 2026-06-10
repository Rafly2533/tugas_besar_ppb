import "package:flutter/material.dart"; 
import "package:firebase_auth/firebase_auth.dart"; 
import "package:google_sign_in/google_sign_in.dart"; 
import "package:http/http.dart" as http;  // WAJIB pakai alias "as http" 
import "dart:convert"; 
 
class AuthProvider with ChangeNotifier { 
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;  // singleton, bukan konstruktor
 
  User? _user; 
  User? get user => _user; 
  bool _initialized = false; 
 
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
    await _googleSignIn.initialize();  // wajib dipanggil sebelum authenticate 
    _googleSignIn.attemptLightweightAuthentication();  // silent sign-in jika sudah pernah login 
  } 
 
  Future<void> signInWithGoogle() async { 
    try { 
      // API baru v7: .authenticate() bukan .signIn() 
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(); 
 
      // Hanya idToken yang tersedia (tidak ada accessToken di v7) 
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
      // EMULATOR: gunakan 10.0.2.2 
      // HP FISIK : gunakan IPv4 WiFi laptop (cek dengan ipconfig) 
      final String baseUrl = "http://128.150.2.126";  // ganti jika pakai HP asli 
 
      debugPrint("Mencoba kirim ke PHP..."); 
      final response = await http.post(  // pastikan pakai http.post (dengan prefix alias) 
        Uri.parse("$baseUrl/tubesppb/login.php"),
        body: {"id_token": idToken}, 
      ); 
 
      debugPrint("Status HTTP: ${response.statusCode}"); 
      debugPrint("Response body: ${response.body}"); 
 
      final responseData = json.decode(response.body); 
      debugPrint("Pesan dari Server PHP: ${responseData["message"]}"); 
 
    } catch (e) { 
      debugPrint("Error login: $e"); 
    } 
  } 
 
  Future<void> signOut() async { 
    await _googleSignIn.signOut(); 
    await _auth.signOut(); 
  } 
}