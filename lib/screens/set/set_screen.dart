import 'package:flutter/material.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({super.key});

  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Set Screen'),
      ),
    );
  }
}