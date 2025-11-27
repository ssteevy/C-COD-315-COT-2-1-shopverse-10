import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// Provider de gestion de l'état d'authentification
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Écouter les changements d'authentification Firebase
  void listenToAuthChanges() {
    _authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        // Utilisateur connecté → Charger son profil
        _currentUser = await _authService.getUserProfile(firebaseUser.uid);
      } else {
        // Utilisateur déconnecté
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // inscription 
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      notifyListeners(); // ← IMPORTANT

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // connexion classique 
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      notifyListeners(); // ← IMPORTANT

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //  connxion google 
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authService.signInWithGoogle();

      notifyListeners(); // ← IMPORTANT

      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //  demander status 
  Future<bool> requestMerchantStatus(String reason) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.requestMerchantStatus(
        userId: _currentUser!.id,
        reason: reason,
      );
      
      // Rafraîchir le profil
      _currentUser = await _authService.getUserProfile(_currentUser!.id);

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // mis a jour profile 
  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.updateUserProfile(
        userId: _currentUser!.id,
        displayName: displayName,
        photoUrl: photoUrl,
      );
      
      // Rafraîchir le profil
      _currentUser = await _authService.getUserProfile(_currentUser!.id);

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //  reinitialse mdp 
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // logout 
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // helpers 
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
