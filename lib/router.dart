import 'package:cabosat/features/bottom_navigation.dart';
import 'package:cabosat/features/login/screens/login_screen.dart';
import 'package:cabosat/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouterWidget extends StatefulWidget {
  const RouterWidget({super.key});

  @override
  State<RouterWidget> createState() => _RouterWidgetState();
}

class _RouterWidgetState extends State<RouterWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, AuthModel auth, child) {
      if (auth.isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (auth.isAuthenticated) {
        return const BottomNavigation();
      }

      return const LoginScreen();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthModel>(context, listen: false).getCurrentUser();
    });
  }
}
