import 'package:flutter/material.dart';
import 'window/Page1/page1.dart';
import 'window/page2.dart';
import 'window/page3.dart';
import 'window/page4.dart';
import '../database/db_manage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManagement.instance.database;  // Initialize the database
  /*await DatabaseManagement.instance.showAllData();  // Call the function to show data*/
  await initializeDateFormatting('th', null);  // Initialize ข้อมูล locale สำหรับภาษาไทย

  runApp(MyApp());  // เริ่มแอปพลิเคชัน
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // ภาษาอังกฤษ
        const Locale('th', ''), // ภาษาไทย
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0 ? 'assets/home_color.png' : 'assets/home_gray.png',
              width: 30,
              height: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1 ? 'assets/dashboard_color.png' : 'assets/dashboard_gray.png',
              width: 30,
              height: 30,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2 ? 'assets/wallet_color.png' : 'assets/wallet_gray.png',
              width: 30,
              height: 30,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3 ? 'assets/budget_color.png' : 'assets/budget_gray.png',
              width: 30,
              height: 30,
            ),
            label: 'Budget',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 50, 50, 50),
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}
