import 'package:cabosat/features/home/widgets/invoice_buttons.dart';
import 'package:cabosat/features/home/widgets/invoice_tag.dart';
import 'package:cabosat/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceWidget extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            style: ListTileStyle.list,
            title: Text(
              "Fatura ${invoice.id} - R\$ ${invoice.valor?.toStringAsFixed(2).replaceAll(".", ",")} ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Vencimento: ${invoice.vencimento}"),
            trailing: InvoiceTag(status: invoice.status!),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: InvoiceButtons(invoice: invoice),
          )
        ],
      ),
    );
  }
}
