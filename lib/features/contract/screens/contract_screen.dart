import 'package:cabosat/features/contract/widgets/contract_information.dart';
import 'package:cabosat/features/contract/widgets/divider_with_text.dart';
import 'package:cabosat/features/home/widgets/blanks_slate.dart';
import 'package:cabosat/models/contract_model.dart';
import 'package:cabosat/provider/contract_provider.dart';
import 'package:cabosat/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  int? filteredContractId;

  String getDocumentType(String? document) {
    if (document == null) return "CPF";

    if (document.replaceAll(".", "").replaceAll("-", "").length == 11) {
      return "CPF";
    }

    return "CNPJ";
  }

  String formatToCurrency(double value) {
    return "R\$ ${value.toStringAsFixed(2).replaceAll(".", ",")}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ContractProvider contract, child) {
        if (contract.isLoading) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (contract.currentContract == null) {
          const Center(child: BlanksSlate());
        }

        ContractModel selectedContract = filteredContractId != null
            ? contract.contracts
                .firstWhere((element) => element.contrato == filteredContractId)
            : contract.currentContract!;

        String documentType = getDocumentType(selectedContract.cpfCnpj);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Contratos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      DropdownButton(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        value: filteredContractId ??
                            contract.currentContract?.contrato,
                        onChanged: (value) => {
                          filteredContractId = value as int,
                          setState(() {})
                        },
                        items: contract.contracts.map((contract) {
                          return DropdownMenuItem(
                            value: contract.contrato,
                            child: SizedBox(
                              width: 170,
                              child: Text(
                                  "${contract.contrato} - ${contract.razaoSocial}asdawdas",
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const DividerWithText(text: "Informações do Contrato"),
                const SizedBox(height: 20),
                ContractInformation(
                  title: documentType == "CPF" ? "Nome" : "Razão Social",
                  description: selectedContract.razaoSocial ?? "",
                ),
                ContractInformation(
                  title: documentType,
                  description: selectedContract.cpfCnpj ?? "",
                ),
                ContractInformation(
                    title: "Plano de Internet",
                    description: selectedContract.planoInternet),
                ContractInformation(
                    title: "Valor do Contrato",
                    description: formatToCurrency(
                        selectedContract.planoInternetValor ?? 0)),
                const DividerWithText(text: "Endereço"),
                const SizedBox(height: 20),
                ContractInformation(
                    title: "Logradouro",
                    description:
                        selectedContract.enderecoInstalacao?.logradouro),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ContractInformation(
                          title: "Cidade",
                          description:
                              selectedContract.enderecoInstalacao?.cidade),
                    ),
                    ContractInformation(
                        title: "Número",
                        description: selectedContract.enderecoInstalacao?.numero
                            .toString()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ContractInformation(
                          title: "Bairro",
                          description:
                              selectedContract.enderecoInstalacao?.bairro),
                    ),
                    ContractInformation(
                        title: "CEP",
                        description: selectedContract.enderecoInstalacao?.cep),
                  ],
                ),
                ContractInformation(
                    title: "Logradouro",
                    description:
                        selectedContract.enderecoInstalacao?.logradouro),
                const Divider(),
                const SizedBox(height: 20),
                RaisedGradientButton(
                  width: double.infinity,
                  onPressed: () async {
                    String url = 'https://wa.me/551236558743';
                    await launchUrl(Uri.parse(url));
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  gradient: const LinearGradient(
                    colors: <Color>[Colors.green, Colors.green],
                  ),
                  child: const Text("Atualizar plano",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
