import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.color,
    required this.title,
    this.body,
    this.actions,
  });
  final Color color;
  final String title;
  final Widget? body;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(title),
        actions: actions,
      ),
      backgroundColor: color,
      body: body,
    );
  }
}
