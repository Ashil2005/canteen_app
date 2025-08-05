import 'package:flutter/material.dart';

void main() {
  runApp(CanteenApp());
}

class CanteenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canteen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: HomePlaceholder(),
    );
  }
}

class HomePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '🚀 Canteen App is Live!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
