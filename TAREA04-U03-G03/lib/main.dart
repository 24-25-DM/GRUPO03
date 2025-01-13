import 'package:flutter/material.dart';
import 'package:persistencia/life_cycle_manager.dart';
import 'package:persistencia/views/login_screen.dart';


void main() {
  runApp(
     LifecycleManager(
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehículos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
     
    );
  }
}
