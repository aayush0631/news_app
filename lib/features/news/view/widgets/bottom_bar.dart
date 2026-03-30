import 'package:flutter/material.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueAccent,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: const Text(
          '© 2024 News App',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}