import 'package:cabosat/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceTag extends StatelessWidget {
  final InvoiceStatus status;
  final String? text;

  const InvoiceTag({
    super.key,
    required this.status,
    this.text,
  });

  props() {
    if (status == InvoiceStatus.Pago) {
      return {
        "color": Colors.green,
        "background": Colors.greenAccent.withOpacity(0.2),
        "text": text ?? 'Pago',
      };
    }

    if (status == InvoiceStatus.Vencido) {
      return {
        "color": Colors.red,
        "background": Colors.redAccent.withOpacity(0.2),
        "text": text ?? 'Vencido',
      };
    }

    return {
      "color": Colors.orange,
      "background": Colors.orangeAccent.withOpacity(0.2),
      "text": text ?? 'Gerado',
    };
  }

  @override
  Widget build(BuildContext context) {
    final tagProps = props();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: tagProps['background'],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: tagProps["color"], width: 1.5),
        ),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Text(
          tagProps["text"],
          style: TextStyle(
            color: tagProps["color"],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
