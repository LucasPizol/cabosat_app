import 'package:cabosat/features/contract/widgets/divider_with_text.dart';
import 'package:cabosat/provider/auth_provider.dart';
import 'package:cabosat/widgets/gradient_button.dart';
import 'package:cabosat/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController cpfcnpjController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, AuthModel auth, child) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Center(
            child: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/cabosat-logo-purple.png',
                              width: 170,
                            ),
                            const SizedBox(height: 10),
                            const Text("Faça seu login",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            const SizedBox(height: 40),
                            CustomTextInput(
                              labelText: 'CPF/CNPJ',
                              controller: cpfcnpjController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(18),
                              ],
                            ),
                            const SizedBox(height: 20),
                            CustomTextInput(
                              labelText: 'Senha',
                              obscureText: true,
                              controller: senhaController,
                            ),
                            const SizedBox(height: 20),
                            RaisedGradientButton(
                                isLoading: auth.isLoading,
                                width: double.infinity,
                                gradient: const LinearGradient(
                                  colors: <Color>[Colors.orange, Colors.red],
                                ),
                                onPressed: () {
                                  auth.login(
                                      cpfcnpj: cpfcnpjController.text,
                                      senha: senhaController.text,
                                      context: context);
                                },
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(height: 20),
                            const DividerWithText(text: "ou"),
                            const SizedBox(height: 20),
                            RaisedGradientButton(
                                isLoading: auth.isLoading,
                                width: double.infinity,
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurple,
                                    Colors.deepPurpleAccent
                                  ],
                                ),
                                onPressed: () async {
                                  String url = 'https://wa.me/551236558743';
                                  await launchUrl(Uri.parse(url));
                                },
                                child: const Text(
                                  'Adquira seu plano',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            )),
          ));
    });
  }
}
