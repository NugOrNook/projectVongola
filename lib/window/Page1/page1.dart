import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vongola/window/Page1/pageAddLog.dart';
import '../../database/db_manage.dart';
import 'CardDashBoard.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'CardFinancial.dart';

class Page1 extends StatefulWidget {
  @override
  _Introduction createState() => _Introduction();
}

class _Introduction extends State<Page1> {
  late Future<List<Map<String, dynamic>>> _transactionsFuture;
  late StreamSubscription _intentSub;
  late String sharingFile = '';

  @override
  void initState() {
    super.initState();
    _transactionsFuture = DatabaseManagement.instance.queryAllTransactions();
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
        setState(() {
          List<SharedMediaFile> sharedFile = value;
          print(sharedFile[0].path);
          Navigator.pushNamed(context, '/addTransactionPage',arguments: sharedFile[0].path);
        });
      }, onError: (err) {
        print("getIntentDataStream error: $err");
      });
  }

  void _refreshTransactions() {
    setState(() {
      _transactionsFuture = DatabaseManagement.instance.queryAllTransactions();
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      //crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่ง widgets ให้อยู่ที่ด้านซ้าย
      children: <Widget>[
        // Text Introduction
        Container(
          padding: EdgeInsets.fromLTRB(20, 50, 15, 0), // จัดตำแหน่ง ซ้าย บน ขวา ล่าง
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
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 20 ),
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
        SizedBox(height: 25,),

        Container(
          height: 250, // กำหนดขนาดที่แน่นอน
          child: CardFinancial(
            transactionsFuture: _transactionsFuture,
          ),
        ),

        // Container(
        //   padding: EdgeInsets.fromLTRB(20, 40, 15, 0),
        //   child: Text(
        //     "Budget in each category",
        //     style: TextStyle(
        //       fontSize: 18,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 15,),
      ],
    ),

        //ปุ่มไปยังหน้าบันทึกรายรายจ่าย
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransaction()),
        );
        
        // ตรวจสอบผลลัพธ์ที่ส่งกลับมา ถ้าเป็น true ให้รีเฟรชข้อมูล
        if (result == true) {
          _refreshTransactions(); // รีเฟรชข้อมูลใหม่ทันทีหลังจากเพิ่มข้อมูลใหม่
        }
      },
      child: const Icon(Icons.add, size: 25,),
    ),
  );
}