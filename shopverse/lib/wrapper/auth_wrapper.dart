import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/client/home.dart';
import '../screens/merchant/home.dart';
import '../screens/admin/home.dart';
import '../screens/auth/login.dart';
import '../models/user.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!auth.isAuthenticated || auth.currentUser == null) {
          return const LoginScreen();
        }

        final user = auth.currentUser!;

        switch (user.role) {
          case UserRole.admin:
            return AdminHomeScreen();

          case UserRole.merchant:
            return const MerchantHomeScreen();

          case UserRole.client:
          default:
            return const ClientHomeScreen();
        }
      },
    );
  }
}
