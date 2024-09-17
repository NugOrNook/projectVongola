import 'package:flutter/material.dart';
import 'pageAddLog.dart';
import '../../database/db_manage.dart';
import 'CardDashBoard.dart';
import 'CardFinancial.dart';

class Page1 extends StatefulWidget {
  @override
  _Introduction createState() => _Introduction();
}

class _Introduction extends State<Page1> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = DatabaseManagement.instance.queryAllTransactions();
  }
  void _refreshTransactions() {
    setState(() {
      _transactionsFuture = DatabaseManagement.instance.queryAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่ง widgets ให้อยู่ที่ด้านซ้าย
      children: <Widget>[
        // Text Introduction
        Container(
          padding: EdgeInsets.fromLTRB(20, 80, 15, 0), // จัดตำแหน่ง ซ้าย บน ขวา ล่าง
          child: Text(
            'Hello, Friend!',
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,  
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 0,   // ระยะห่างด้านบน
            bottom: 0, // ระยะห่างด้านล่าง
            left: 20
          ),
          child: Text(
            "Let's start accounting for expenses",
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 121, 121, 121),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Card DashBoard
        Padding(
          padding: EdgeInsets.only(
            top: 20,   // ระยะห่างด้านบน
            bottom: 20, // ระยะห่างด้านล่าง
          ),
          child: CardDashBoard(),
        ),

        // "Budget in each category"
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 15, 0),
          child: Text(
            "Budget in each category",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),

        Expanded(
          child: CardFinancial(
            transactionsFuture: _transactionsFuture,
          ), // ส่ง Future ให้กับ CardFinancial
        ),

        // Card 
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       padding: EdgeInsets.symmetric(vertical: 20.0), // ระยะห่างบนและล่างของ Card
        //       child: CardFinancial(transactionsFuture: _transactionsFuture),
        //     )
        //   ]
        // ), 
      ],
    ),

        //ปุ่มไปยังหน้าบันทึกรายรายจ่าย
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransaction()),
        );
        _refreshTransactions(); // รีเฟรชข้อมูลเมื่อกลับมาจากหน้า AddTransaction
      },
      child: const Icon(Icons.add, size: 25,),
    ),
  );
}