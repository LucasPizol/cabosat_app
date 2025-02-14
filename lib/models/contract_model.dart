class ContractModel {
  String? status;
  String? razaoSocial;
  double? planoInternetValor;
  Endereco? enderecoInstalacao;
  String? cpfCnpj;
  int? vencimento;
  String? planoTv;
  Endereco? enderecoCobranca;
  String? planoTvId;
  String? planoInternet;
  List<String>? emails;
  String? planoTelefoniaId;
  String? planoMultimidiaId;
  String? planoTelefonia;
  String? planoMultimidia;
  int? contrato;
  String? planoInternetId;

  ContractModel({
    required this.status,
    required this.razaoSocial,
    required this.planoInternetValor,
    required this.enderecoInstalacao,
    required this.cpfCnpj,
    required this.vencimento,
    required this.planoTv,
    required this.enderecoCobranca,
    required this.planoTvId,
    required this.planoInternet,
    required this.emails,
    required this.planoTelefoniaId,
    required this.planoMultimidiaId,
    required this.planoTelefonia,
    required this.planoMultimidia,
    required this.contrato,
    required this.planoInternetId,
  });

  // Método para deserializar o JSON
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      status: json['status'].trim(),
      razaoSocial: json['razaosocial'],
      planoInternetValor: json['planointernet_valor'].toDouble(),
      enderecoInstalacao: Endereco.fromJson(json['endereco_instalacao']),
      cpfCnpj: json['cpfcnpj'],
      vencimento: json['vencimento'],
      planoTv: json['planotv'],
      enderecoCobranca: Endereco.fromJson(json['endereco_cobranca']),
      planoTvId: json['planotv_id'],
      planoInternet: json['planointernet'],
      emails: List<String>.from(json['emails']),
      planoTelefoniaId: json['planotelefonia_id'],
      planoMultimidiaId: json['planomultimidia_id'],
      planoTelefonia: json['planotelefonia'],
      planoMultimidia: json['planomultimidia'],
      contrato: json['contrato'],
      planoInternetId: json['planointernet_id'],
    );
  }

  // Método para serializar o objeto de volta para JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'razaosocial': razaoSocial,
      'planointernet_valor': planoInternetValor,
      'endereco_instalacao': enderecoInstalacao?.toJson(),
      'cpfcnpj': cpfCnpj,
      'vencimento': vencimento,
      'planotv': planoTv,
      'endereco_cobranca': enderecoCobranca?.toJson(),
      'planotv_id': planoTvId,
      'planointernet': planoInternet,
      'emails': emails,
      'planotelefonia_id': planoTelefoniaId,
      'planomultimidia_id': planoMultimidiaId,
      'planotelefonia': planoTelefonia,
      'planomultimidia': planoMultimidia,
      'contrato': contrato,
      'planointernet_id': planoInternetId,
    };
  }
}

class Endereco {
  String? logradouro;
  int? numero;
  String? bairro;
  String? cidade;
  String? uf;
  String? cep;
  String? complemento;

  Endereco({
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.cep,
    this.complemento,
  });

  // Método para deserializar o JSON
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      logradouro: json['logradouro'],
      numero: json['numero'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      uf: json['uf'],
      cep: json['cep'],
      complemento: json['complemento'],
    );
  }

  // Método para serializar o objeto de volta para JSON
  Map<String, dynamic> toJson() {
    return {
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'cep': cep,
      'complemento': complemento,
    };
  }
}
