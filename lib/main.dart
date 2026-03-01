import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin/screens/admin_home.dart';
import 'auth/presentation/pages/login_page.dart';
import 'auth/presentation/providers/auth_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthNotifier()..init(),
      child: const KajamartApp(),
    ),
  );
}

class KajamartApp extends StatelessWidget {
  const KajamartApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00C853);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kajamart',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isMobilePlatform) {
      return const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Esta aplicación solo permite acceso desde móvil (Android/iOS).',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final session = auth.session;
    if (session == null) {
      return const LoginPage();
    }

    return AdminHomeScreen(session: session);
  }

  bool get _isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
