import 'package:flutter_animation_assignment/assignments/assignment1.dart';
import 'package:flutter_animation_assignment/assignments/assignment2.dart';
import 'package:flutter_animation_assignment/assignments/assignment3.dart';
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
    GoRoute(
      name: RouterName.assignment2,
      path: RouterName.assignment2Url,
      builder: (context, state) => const Assignment2(),
    ),
    GoRoute(
      name: RouterName.assignment3,
      path: RouterName.assignment3Url,
      builder: (context, state) => const Assignment3(),
    ),
  ],
);
