// lib/providers/auth_provider.dart

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

  // ==========================================
  // INSCRIPTION
  // ==========================================
  
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
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // CONNEXION EMAIL/PASSWORD
  // ==========================================
  
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
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // CONNEXION GOOGLE
  // ==========================================
  
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authService.signInWithGoogle();
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // DEMANDER STATUT COMMERÇANT
  // ==========================================
  
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
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // METTRE À JOUR PROFIL
  // ==========================================
  
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
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // RÉINITIALISER MOT DE PASSE
  // ==========================================
  
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // DÉCONNEXION
  // ==========================================
  
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

  // ==========================================
  // HELPERS PRIVÉS
  // ==========================================
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}