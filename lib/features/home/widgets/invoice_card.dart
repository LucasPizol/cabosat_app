import 'package:cabosat/features/home/widgets/invoice_buttons.dart';
import 'package:cabosat/features/home/widgets/invoice_tag.dart';
import 'package:cabosat/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceCard({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(),
      clipBehavior: Clip.values[1],
      child: ListTile(
        title: Container(
            decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 84, 20, 143),
            ),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Text(
              "Fatura do dia ${invoice.vencimentoAtualizado}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )),
        subtitle: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "R\$ ${invoice.valorCorrigido?.toStringAsFixed(2).replaceAll('.', ',')}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 53, 53, 53),
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  InvoiceTag(status: invoice.status!)
                ],
              ),
              const SizedBox(height: 10),
              InvoiceButtons(invoice: invoice),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.all(0),
        minVerticalPadding: 0,
      ),
    );
  }
}
