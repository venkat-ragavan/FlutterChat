import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesuvom'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 95, 156, 242),
              Color.fromARGB(255, 100, 238, 215),
            ],
            begin: AlignmentGeometry.bottomLeft,
            end: AlignmentGeometry.topRight,
          ),
        ),
        child: const Center(
          child: Text('Loading...')
        ),
      ),
    );
  }
}