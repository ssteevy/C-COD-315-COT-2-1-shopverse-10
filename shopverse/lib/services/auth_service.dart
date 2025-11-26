import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  // Instances Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream des changements d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Utilisateur Firebase connecté
  User? get currentUser => _auth.currentUser;

//  inscription classique 
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // crrer  compte Firebase Auth
      UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //  le nom d'affichage
      await userCredential.user?.updateDisplayName(displayName);

// create profile 
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        role: UserRole.client, 
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toFirestore());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erreur lors de l\'inscription: $e';
    }
  }

// connexion classique 
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // connecter avec Firebase Auth
      UserCredential userCredential = 
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // récupérer le profil depuis Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw 'Profil utilisateur introuvable';
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erreur lors de la connexion: $e';
    }
  }
// connexion avec google 
  Future<UserModel?> signInWithGoogle() async {
    try {
      //  Déclencher le flux Google SignIn
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; 
      }

      // Obtenir les tokens 
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      //les credentials Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // conncter avec Firebase
      UserCredential userCredential = 
          await _auth.signInWithCredential(credential);

      // vérifier si le profil existe déjà
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // si Nouveau compte Google creer profile user 
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          role: UserRole.client,
          displayName: userCredential.user!.displayName ?? 'Utilisateur',
          photoUrl: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toFirestore());

        return newUser;
      }

      // Compte existant
      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erreur lors de la connexion Google: $e';
    }
  }

//  demande etre commercant
  Future<void> requestMerchantStatus({
    required String userId,
    required String reason,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'merchantRequestStatus': MerchantRequestStatus.pending.name,
        'merchantRequestReason': reason,
        'merchantRequestDate': FieldValue.serverTimestamp(),
        'rejectionReason': null, // Reset si nouvelle demande
      });

      print(' Demande commerçant envoyée pour $userId');
      // TODO: Notifier les admins
    } catch (e) {
      throw 'Erreur lors de la demande: $e';
    }
  }

// approuver une demande 
  Future<void> approveMerchantRequest(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': UserRole.merchant.name, // ← Promotion
        'merchantRequestStatus': MerchantRequestStatus.approved.name,
        'merchantApprovalDate': FieldValue.serverTimestamp(),
        'rejectionReason': null,
      });

      print(' Demande approuvée pour $userId');
      // TODO: Notifier l'utilisateur
    } catch (e) {
      throw 'Erreur lors de l\'approbation: $e';
    }
  }

// rejeter une demande 
  Future<void> rejectMerchantRequest(String userId, String reason) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'merchantRequestStatus': MerchantRequestStatus.rejected.name,
        'rejectionReason': reason,
        'merchantApprovalDate': FieldValue.serverTimestamp(),
      });

      print(' Demande rejetée pour $userId');
      // TODO: Notifier l'utilisateur
    } catch (e) {
      throw 'Erreur lors du rejet: $e';
    }
  }

//  recup demandes en attente 
  Stream<List<UserModel>> getPendingMerchantRequests() {
    return _firestore
        .collection('users')
        .where('merchantRequestStatus', isEqualTo: 'pending')
        .orderBy('merchantRequestDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

//  recup user profil 
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc = 
          await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) return null;
      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw 'Erreur lors de la récupération du profil: $e';
    }
  }

// mettre a jour profile 
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (displayName != null) updates['displayName'] = displayName;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update(updates);

        // Mettre à jour Firebase Auth aussi
        if (displayName != null) {
          await currentUser?.updateDisplayName(displayName);
        }
        if (photoUrl != null) {
          await currentUser?.updatePhotoURL(photoUrl);
        }
      }
    } catch (e) {
      throw 'Erreur lors de la mise à jour du profil: $e';
    }
  }

// reinitialise mdp 
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
// logout 
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Erreur lors de la déconnexion: $e';
    }
  }

// gerer erreurs firebase 
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'weak-password':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'account-exists-with-different-credential':
        return 'Un compte existe déjà avec cet email';
      case 'invalid-credential':
        return 'Les identifiants sont invalides';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      default:
        return 'Erreur d\'authentification: ${e.message}';
    }
  }
}