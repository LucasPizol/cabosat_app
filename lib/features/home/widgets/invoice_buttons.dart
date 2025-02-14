import 'package:cabosat/models/invoice_model.dart';
import 'package:cabosat/services/file_system_service.dart';
import 'package:cabosat/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvoiceButtons extends StatefulWidget {
  final InvoiceModel invoice;

  const InvoiceButtons({super.key, required this.invoice});

  @override
  State<InvoiceButtons> createState() => _InvoiceButtonsState();
}

class _InvoiceButtonsState extends State<InvoiceButtons> {
  Widget getButtons() {
    if (widget.invoice.status == InvoiceStatus.Pago) {
      if (widget.invoice.recibo == null) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RaisedGradientButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Baixando recibo..."),
                    duration: Duration(seconds: 2),
                  ),
                );
                await FileSystemService().saveFile(
                    widget.invoice.recibo!, "Recibo__${widget.invoice.id}");
              },
              gradient: const LinearGradient(
                colors: <Color>[Colors.orange, Colors.red],
              ),
              height: 40.0,
              icon: const Icon(Icons.download, color: Colors.white, size: 16.0),
              child:
                  const Text("Recibo", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    Map<String, dynamic> commonButtonProps = {"height": 40.0, "iconSize": 16.0};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaisedGradientButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Baixando fatura..."),
                duration: Duration(seconds: 2),
              ),
            );

            await FileSystemService().saveFile(
                widget.invoice.linkCompleto!, "Fatura__${widget.invoice.id}");
          },
          gradient: const LinearGradient(
            colors: <Color>[Colors.orange, Colors.red],
          ),
          icon: Icon(Icons.print,
              color: Colors.white, size: commonButtonProps["iconSize"]),
          height: commonButtonProps["height"],
          child: const Text("Imprimir",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.invoice.linhaDigitavel != null
                ? RaisedGradientButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.invoice.linhaDigitavel!));
                    },
                    gradient: const LinearGradient(
                      colors: <Color>[Colors.blue, Colors.blue],
                    ),
                    icon: Icon(Icons.copy,
                        color: Colors.white,
                        size: commonButtonProps["iconSize"]),
                    height: commonButtonProps["height"],
                    child: const Text("Código boleto",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )
                : const SizedBox.shrink(),
            widget.invoice.codigoPix != null
                ? const SizedBox(width: 10)
                : const SizedBox.shrink(),
            widget.invoice.codigoPix != null
                ? RaisedGradientButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.invoice.codigoPix!));
                    },
                    gradient: const LinearGradient(
                      colors: <Color>[Colors.blue, Colors.blue],
                    ),
                    icon: Icon(Icons.copy,
                        color: Colors.white,
                        size: commonButtonProps["iconSize"]),
                    height: commonButtonProps["height"],
                    child: const Text("Código pix",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )
                : const SizedBox.shrink(),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return getButtons();
  }

  @override
  void initState() {
    super.initState();
  }
}
