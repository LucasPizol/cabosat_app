import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/provider/home_navigation_provider.dart';
import 'package:cabosat/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({super.key});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool isLoading = true;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ContractProvider contract, child) {
      if (contract.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (contract.currentContract == null) {
        return const Center(
          child: Text("Nenhum contrato encontrado"),
        );
      }

      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Colors.orange,
              Colors.red,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contract.currentContract?.planoInternet ?? "",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "R\$ ${contract.currentContract?.planoInternetValor?.toStringAsFixed(2).replaceAll(".", ",")}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer(builder:
                (context, HomeNavigationProvider homeNavigation, child) {
              return RaisedGradientButton(
                onPressed: () {
                  homeNavigation.setIndex(2);
                },
                height: 40,
                width: 150,
                gradient: const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
                child: const Text(
                  "Mais informações",
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              );
            })
          ],
        ),
      );
    });
  }
}
