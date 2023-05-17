import 'package:flutter/material.dart';

class QuizCheckerPage extends StatelessWidget {
  const QuizCheckerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizChecker'),
      ),
      body: Row(
        children: [
          Flexible(
              child: Container(
                  margin: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('drag file here1')))),
          Flexible(
              child: Container(
                  margin: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('drag file here1')))),
        ],
      ),
    );
  }
}
