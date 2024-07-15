import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.title,
    this.body,
  });

  final String title;
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}
