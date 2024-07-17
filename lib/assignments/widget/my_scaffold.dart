import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.color,
    required this.title,
    this.body,
  });
  final Color color;
  final String title;
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(title),
      ),
      backgroundColor: color,
      body: body,
    );
  }
}
