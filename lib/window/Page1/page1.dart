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
       // _sharedFiles.clear();
        print("***************************144*****144");
       // _sharedFiles.addAll(value);

        List<SharedMediaFile> sharedFile = value;
        print(sharedFile[0].path);
        Navigator.pushNamed(context, '/addTransactionPage',arguments: sharedFile[0].path);

        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

        });
      }, onError: (err) {
        print("getIntentDataStream error: $err");
      });
    // Get the media sharing coming from outside the app while the app is closed.
    // ReceiveSharingIntent.instance.getInitialMedia().then((value) {
    //   setState(() {
    //     print("***************************155555555555555*****15555555555555555");
    //
    //     Navigator.pushNamed(context, 'addTransactionPage');
    //     // Tell the library that we are done processing the intent.
    //     ReceiveSharingIntent.instance.reset();
    //   });
    // });
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