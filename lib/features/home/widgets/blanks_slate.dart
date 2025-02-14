import 'package:flutter/material.dart';

class BlanksSlate extends StatelessWidget {
  const BlanksSlate({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 84, 20, 143),
            ),
            child: Image.asset(
              'assets/images/cabosat-logo.png',
              width: 100,
            ),
          ),
          const SizedBox(height: 20),
          const Text("Nenhum dado encontrado"),
        ],
      ),
    );
  }
}
