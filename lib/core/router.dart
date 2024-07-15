import 'package:flutter_animation_assignment/core/assignments/assignment1.dart';
import 'package:flutter_animation_assignment/core/router_name.dart';
import 'package:flutter_animation_assignment/my_home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: RouterName.myHomePageUrl,
  routes: [
    GoRoute(
      name: RouterName.myHomePage,
      path: RouterName.myHomePageUrl,
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      name: RouterName.assignment1,
      path: RouterName.assignment1Url,
      builder: (context, state) => const Assignment1(),
    ),
  ],
);
