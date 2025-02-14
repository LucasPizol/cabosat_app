import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/provider/home_navigation_provider.dart';
import 'package:cabosat/provider/invoices_provider.dart';
import 'package:cabosat/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpiredInvoiceAlert extends StatelessWidget {
  final List<InvoiceModel> expiredInvoices;

  const ExpiredInvoiceAlert({
    super.key,
    required this.expiredInvoices,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, HomeNavigationProvider homeNavigation, child) {
      return Consumer(builder: (context, InvoiceModelProvider invoices, child) {
        if (invoices.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (expiredInvoices.isEmpty) {
          return Container();
        }

        if (expiredInvoices.length == 1) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(240, 241, 106, 106),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Fatura em atraso",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      Text(
                          "Fatura vencida em ${expiredInvoices.first.vencimentoAtualizado}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 12)),
                    ],
                  ),
                ),
                RaisedGradientButton(
                  onPressed: () {
                    homeNavigation.setIndex(1);
                  },
                  height: 40,
                  gradient: const LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                  child: const Text("Ver fatura",
                      style: TextStyle(
                          color: Color.fromARGB(240, 241, 106, 106),
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(240, 241, 106, 106),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fatura em atraso",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Text("${expiredInvoices.length} faturas vencidas",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 12)),
                  ],
                ),
              ),
              RaisedGradientButton(
                onPressed: () {
                  homeNavigation.setIndex(1);
                },
                height: 40,
                gradient: const LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
                child: const Text("Ver faturas",
                    style: TextStyle(
                        color: Color.fromARGB(240, 241, 106, 106),
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      });
    });
  }
}
