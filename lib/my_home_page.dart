import 'package:flutter/material.dart';
import 'package:flutter_animation_assignment/core/router_name.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _onPressed(BuildContext context) {
    context.pushNamed(RouterName.assignment1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('youngbok\'s animations'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _onPressed(context),
              child: const Text("assignment 1"),
            ),
          ],
        ),
      ),
    );
  }
}
