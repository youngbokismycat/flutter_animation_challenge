import 'package:flutter/material.dart';
import 'package:flutter_animation_assignment/core/router_name.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _onPressed(
    BuildContext context,
    String named,
  ) {
    context.pushNamed(named);
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
              onPressed: () => _onPressed(context, RouterName.assignment1),
              child: const Text("assignment 1"),
            ),
            ElevatedButton(
              onPressed: () => _onPressed(context, RouterName.assignment2),
              child: const Text("assignment 2"),
            ),
            ElevatedButton(
              onPressed: () => _onPressed(context, RouterName.assignment3),
              child: const Text("assignment 3"),
            ),
            ElevatedButton(
              onPressed: () => _onPressed(context, RouterName.assignment4),
              child: const Text("assignment 4"),
            ),
            ElevatedButton(
              onPressed: () => _onPressed(context, RouterName.assignment5),
              child: const Text("assignment 5"),
            ),
          ],
        ),
      ),
    );
  }
}
