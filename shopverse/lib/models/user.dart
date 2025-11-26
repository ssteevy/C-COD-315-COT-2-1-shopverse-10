import 'package:cloud_firestore/cloud_firestore.dart';

// roles 
enum UserRole { 
  admin,     
  merchant, 
  client      
}

/// Statuts de demande commerçant
enum MerchantRequestStatus { 
  none,       
  pending,   
  approved,  
  rejected   
}

///usr
class UserModel {
  final String id;
  final String email;
  final UserRole role;
  final String displayName;
  final String? photoUrl;
  final String? shopId;  
  final DateTime createdAt;
  
  // Gestion demandes commerçant
  final MerchantRequestStatus merchantRequestStatus;
  final String? merchantRequestReason;
  final DateTime? merchantRequestDate;
  final DateTime? merchantApprovalDate;
  final String? rejectionReason;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.displayName,
    this.photoUrl,
    this.shopId,
    required this.createdAt,
    this.merchantRequestStatus = MerchantRequestStatus.none,
    this.merchantRequestReason,
    this.merchantRequestDate,
    this.merchantApprovalDate,
    this.rejectionReason,
  });

  /// Convertir depuis Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      role: _roleFromString(data['role'] ?? 'client'),
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      shopId: data['shopId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      merchantRequestStatus: _statusFromString(
        data['merchantRequestStatus'] ?? 'none'
      ),
      merchantRequestReason: data['merchantRequestReason'],
      merchantRequestDate: data['merchantRequestDate'] != null
          ? (data['merchantRequestDate'] as Timestamp).toDate()
          : null,
      merchantApprovalDate: data['merchantApprovalDate'] != null
          ? (data['merchantApprovalDate'] as Timestamp).toDate()
          : null,
      rejectionReason: data['rejectionReason'],
    );
  }

  /// Convertir vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role.name,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'shopId': shopId,
      'createdAt': Timestamp.fromDate(createdAt),
      'merchantRequestStatus': merchantRequestStatus.name,
      'merchantRequestReason': merchantRequestReason,
      'merchantRequestDate': merchantRequestDate != null
          ? Timestamp.fromDate(merchantRequestDate!)
          : null,
      'merchantApprovalDate': merchantApprovalDate != null
          ? Timestamp.fromDate(merchantApprovalDate!)
          : null,
      'rejectionReason': rejectionReason,
    };
  }

  /// Helpers de conversion
  static UserRole _roleFromString(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'merchant':
        return UserRole.merchant;
      default:
        return UserRole.client;
    }
  }

  static MerchantRequestStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return MerchantRequestStatus.pending;
      case 'approved':
        return MerchantRequestStatus.approved;
      case 'rejected':
        return MerchantRequestStatus.rejected;
      default:
        return MerchantRequestStatus.none;
    }
  }

  /// Helper : Peut demander statut commerçant ?
  bool get canRequestMerchantStatus =>
      role == UserRole.client && 
      merchantRequestStatus == MerchantRequestStatus.none;

  /// Helper : A une demande en attente ?
  bool get hasPendingMerchantRequest =>
      merchantRequestStatus == MerchantRequestStatus.pending;

  /// Helper : Demande rejetée ?
  bool get hasRejectedMerchantRequest =>
      merchantRequestStatus == MerchantRequestStatus.rejected;

  /// Copier avec modifications
  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? shopId,
    UserRole? role,
    MerchantRequestStatus? merchantRequestStatus,
    String? merchantRequestReason,
    DateTime? merchantRequestDate,
    DateTime? merchantApprovalDate,
    String? rejectionReason,
  }) {
    return UserModel(
      id: id,
      email: email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt,
      merchantRequestStatus: merchantRequestStatus ?? this.merchantRequestStatus,
      merchantRequestReason: merchantRequestReason ?? this.merchantRequestReason,
      merchantRequestDate: merchantRequestDate ?? this.merchantRequestDate,
      merchantApprovalDate: merchantApprovalDate ?? this.merchantApprovalDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, role: ${role.name}, displayName: $displayName)';
  }
}