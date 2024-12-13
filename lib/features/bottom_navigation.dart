import 'package:cabosat/features/contract/screens/contract_screen.dart';
import 'package:cabosat/features/home/screens/home_screen.dart';
import 'package:cabosat/features/home/screens/invoices_screen.dart';
import 'package:cabosat/features/home/widgets/home_scaffold.dart';
import 'package:cabosat/features/home/widgets/invoice_card.dart';
import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/provider/home_navigation_provider.dart';
import 'package:cabosat/provider/invoices_provider.dart';
import 'package:cabosat/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with WidgetsBindingObserver {
  List<Map> screens = [
    {
      "screen": const HomeScreen(),
      "icon": const Icon(Icons.home),
      "label": "Início",
    },
    {
      "screen": const InvoiceScreen(),
      "icon": const Icon(FontAwesomeIcons.barcode),
      "label": "Faturas",
    },
    {
      "screen": const ContractScreen(),
      "icon": const Icon(FontAwesomeIcons.fileContract),
      "label": "Contratos",
    },
  ];

  Widget getInvoiceContent(InvoiceModel? lastInvoice, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    bool isEmpty = lastInvoice == null;

    return isEmpty
        ? const Center(
            child: Text("Nenhuma fatura encontrada"),
          )
        : InvoiceCard(
            invoice: lastInvoice,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeNavigationProvider(),
        child: Consumer(
            builder: (context, HomeNavigationProvider homeProvider, child) {
          return HomeScaffold(
              bottomNavigationBar: BottomNavigationBar(
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                type: BottomNavigationBarType.fixed,
                enableFeedback: true,
                items: screens.map((screen) {
                  return BottomNavigationBarItem(
                    icon: screen["icon"],
                    label: screen["label"],
                    activeIcon: screen["icon"],
                  );
                }).toList(),
                currentIndex: homeProvider.currentIndex,
                selectedItemColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 84, 20, 143),
                unselectedItemColor: Colors.white.withOpacity(0.5),
                onTap: (index) {
                  homeProvider.setIndex(index);
                },
              ),
              body: SizedBox(
                child: screens[homeProvider.currentIndex]["screen"],
                height: double.infinity,
              ));
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<InvoiceModelProvider>(context, listen: false).loadInvoices();
      await Provider.of<ContractProvider>(context, listen: false)
          .loadContracts();

      String? topic =
          Provider.of<ContractProvider>(context, listen: false).topic;

      if (topic == null) {
        await Provider.of<NotificationProvider>(context, listen: false)
            .loadLocalNotifications();
        return;
      }

      await Provider.of<NotificationProvider>(context, listen: false)
          .loadNotifications(topic);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Provider.of<NotificationProvider>(context, listen: false)
          .loadLocalNotifications();
    }
  }
}
