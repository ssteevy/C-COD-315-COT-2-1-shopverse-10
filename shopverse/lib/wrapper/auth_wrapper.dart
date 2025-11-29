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

        if (auth.currentUser == null) {
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
// InputConnectionAdaptor(16391): The input method toggled cursor monitoring on
// D/InputConnectionAdaptor(16391): The input method toggled cursor monitoring off
// D/InputConnectionAdaptor(16391): The input method toggled cursor monitoring on
// D/InsetsController(16391): show(ime(), fromIme=true)
// D/InsetsController(16391): show(ime(), fromIme=true)
// I/FirebaseAuth(16391): Creating user with nouveau@gmail.com with empty reCAPTCHA token
// W/System  (16391): Ignoring header X-Firebase-Locale because its value was null.
// W/System  (16391): Ignoring header X-Firebase-Locale because its value was null.
// D/FirebaseAuth(16391): Notifying id token listeners about user ( f5OdEjz8LGNLtDxsiWU4sWvJXSy2 ).
// D/FirebaseAuth(16391): Notifying auth state listeners about user ( f5OdEjz8LGNLtDxsiWU4sWvJXSy2 ).
// W/System  (16391): Ignoring header X-Firebase-Locale because its value was null.
// W/System  (16391): Ignoring header X-Firebase-Locale because its value was null.
// W/System  (16391): Ignoring header X-Firebase-Locale because its value was null.
// I/ScrollIdentify(16391): on fling
// I/ample.shopverse(16391): Background concurrent mark compact GC freed 4934KB AllocSpace bytes, 17(660KB) LOS objects, 49% free, 5780KB/11MB, paused 1.183ms,8.008ms total 87.806ms
// I/ScrollIdentify(16391): on fling ca dit quoi? 