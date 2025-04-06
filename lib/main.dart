import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'car_list_page.dart';
import 'sales_list_page.dart';
import 'dealership_list_page.dart';
import 'customerListPage.dart';

void main() {
  // Initialize sqflite_common_ffi ONLY on supported native desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/Main': (context) => const MyHomePage(title: 'Flutter Application Home'),
        '/page1': (context) => const CustomerListPage(title: 'Customer List'),
        '/page2': (context) => CarListPage(),
        '/page3': (context) => const DealershipListPage(),
        '/page4': (context) => const SalesListPage(),
      },
      initialRoute: '/Main',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildNavButton('Customer List', '/page1', buttonStyle),
            const SizedBox(height: 20),
            buildNavButton('Car List', '/page2', buttonStyle),
            const SizedBox(height: 20),
            buildNavButton('Car Dealership List', '/page3', buttonStyle),
            const SizedBox(height: 20),
            buildNavButton('Sales List', '/page4', buttonStyle),
          ],
        ),
      ),
    );
  }

  Widget buildNavButton(String text, String route, ButtonStyle style) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
        style: style,
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(text),
      ),
    );
  }
}
