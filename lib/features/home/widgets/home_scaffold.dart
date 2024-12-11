import 'package:cabosat/provider/auth_provider.dart';
import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const HomeScaffold({super.key, required this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, AuthModel auth, child) {
      return Consumer(
          builder: (context, NotificationProvider notification, child) {
        int notificationCount = notification.getUnreadNotifications();

        return Scaffold(
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String url = 'https://wa.me/551236558743';
              await launchUrl(Uri.parse(url));
            },
            backgroundColor: const Color.fromARGB(255, 99, 203, 92),
            child: const Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 84, 20, 143),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: Image.asset(
              'assets/images/cabosat-logo.png',
              width: 100,
            ),
            actions: [
              Badge(
                label: Text(notificationCount.toString()),
                isLabelVisible: notificationCount > 0,
                offset: const Offset(-25, 25),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                ),
              ),
              Consumer(builder: (context, ContractProvider contract, child) {
                return IconButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/');

                    String? city =
                        contract.currentContract?.enderecoInstalacao?.cidade;

                    if (city != null) {
                      String cityNormalized = city
                          .toLowerCase()
                          .replaceAll(' ', '_')
                          .replaceAll('á', 'a')
                          .replaceAll('é', 'e')
                          .replaceAll('í', 'i')
                          .replaceAll('ó', 'o')
                          .replaceAll('ú', 'u')
                          .replaceAll('ã', 'a')
                          .replaceAll('õ', 'o')
                          .replaceAll('â', 'a')
                          .replaceAll('ê', 'e')
                          .replaceAll('î', 'i')
                          .replaceAll('ô', 'o')
                          .replaceAll('û', 'u')
                          .replaceAll('ç', 'c');

                      await FirebaseMessaging.instance
                          .unsubscribeFromTopic(cityNormalized);
                    }

                    auth.logout();
                  },
                  icon: const Icon(Icons.logout),
                  color: Colors.white,
                );
              }),
            ],
          ),
          body: body,
        );
      });
    });
  }
}
