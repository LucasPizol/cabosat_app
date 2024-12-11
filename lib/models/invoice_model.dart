// ignore: constant_identifier_names
import 'package:intl/intl.dart';

enum InvoiceStatus { Gerado, Pago, Vencido }

class InvoiceModel {
  String? vencimentoAtualizado;
  InvoiceStatus? status;
  String? dataPagamento;
  String? idTransacao;
  String? codigoPix;
  bool? pagarCartaoCheckout;
  String? linkCompleto;
  int? numeroDocumento;
  String? recibo;
  bool? geraPix;
  int? statusId;
  String? vencimento;
  bool? pagarCartaoDebito;
  double? valorCorrigido;
  double? valor;
  String? link;
  String? linhaDigitavel;
  bool? pagarCartao;
  int? id;

  InvoiceModel({
    required this.vencimentoAtualizado,
    required this.status,
    required this.dataPagamento,
    required this.idTransacao,
    required this.codigoPix,
    this.pagarCartaoCheckout,
    required this.linkCompleto,
    required this.numeroDocumento,
    required this.recibo,
    required this.geraPix,
    required this.statusId,
    required this.vencimento,
    required this.pagarCartaoDebito,
    required this.valorCorrigido,
    required this.valor,
    required this.link,
    required this.linhaDigitavel,
    required this.pagarCartao,
    required this.id,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    bool isExpired = DateTime.now()
            .add(
              const Duration(days: 1),
            )
            .isAfter(DateTime.parse(json['vencimento'])) &&
        json['status'] != 'Pago';

    InvoiceStatus status =
        json['status'] == 'Pago' ? InvoiceStatus.Pago : InvoiceStatus.Gerado;

    DateFormat formatter = DateFormat('dd/MM/yyyy', 'pt_BR');

    String vencimento = json['vencimento'] != null
        ? formatter.format(DateTime.parse(json["vencimento"]))
        : '';

    String dataPagamento = json['data_pagamento'] != null
        ? formatter.format(DateTime.parse(json["data_pagamento"]))
        : '';

    String vencimentoAtualizado = json['vencimento_atualizado'] != null
        ? formatter.format(DateTime.parse(json["vencimento_atualizado"]))
        : '';

    return InvoiceModel(
      vencimentoAtualizado: vencimentoAtualizado,
      status: isExpired ? InvoiceStatus.Vencido : status,
      dataPagamento: dataPagamento,
      idTransacao: json['idtransacao'],
      codigoPix: json['codigopix'],
      pagarCartaoCheckout: json['pagarcartaocheckout'],
      linkCompleto: json['link_completo'],
      numeroDocumento: json['numero_documento'],
      recibo: json['recibo'],
      geraPix: json['gerapix'],
      statusId: json['statusid'],
      vencimento: vencimento,
      pagarCartaoDebito: json['pagarcartaodebito'],
      valorCorrigido: json['valorcorrigido'].toDouble(),
      valor: json['valor'].toDouble(),
      link: json['link'],
      linhaDigitavel: json['linhadigitavel'],
      pagarCartao: json['pagarcartao'],
      id: json['id'],
    );
  }
}
