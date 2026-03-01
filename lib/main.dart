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

    final session = auth.session;
    final home = session == null ? const LoginPage() : AdminHomeScreen(session: session);

    if (_isStrictMobilePlatform) {
      return home;
    }

    if (_isDesktopDebugMode) {
      return Stack(
        children: [
          home,
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Material(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Modo pruebas en PC habilitado. En producción el acceso sigue siendo móvil.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }

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

  bool get _isStrictMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool get _isDesktopDebugMode {
    return !kIsWeb &&
        kDebugMode &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);
  }
}
