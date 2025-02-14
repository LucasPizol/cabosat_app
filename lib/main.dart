import 'package:cabosat/features/bottom_navigation.dart';
import 'package:cabosat/features/login/screens/login_screen.dart';
import 'package:cabosat/firebase_options.dart';
import 'package:cabosat/features/notification/screens/notification_screen.dart';
import 'package:cabosat/provider/auth_provider.dart';
import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/provider/invoices_provider.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:cabosat/services/notifications/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR', null);
  await NotificationService.instance.initialize();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthModel()),
      ChangeNotifierProvider(create: (_) => InvoiceModelProvider()),
      ChangeNotifierProvider(create: (_) => ContractProvider()),
      ChangeNotifierProvider(create: (_) {
        NotificationProvider notificationProvider = NotificationProvider();
        NotificationService.instance
            .setNotificationProvider(notificationProvider);

        return notificationProvider;
      }),
    ], child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'OktaNeue'),
      home: const AuthGate(),
      routes: {
        '/notifications': (context) => const NotificationScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, AuthModel auth, child) {
        return FutureBuilder(
          future: auth.getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Erro ao carregar usuário'),
                ),
              );
            }

            if (auth.isAuthenticated) {
              return const BottomNavigation();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}
