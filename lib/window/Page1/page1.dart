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
  late Future<List<Map<String, dynamic>>> _cardFuture;
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();
    _refreshData();
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        List<SharedMediaFile> sharedFile = value;
        print(sharedFile[0].path);
        Navigator.pushNamed(context, '/addTransactionPage', arguments: sharedFile[0].path);
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });
  }

  void _refreshData() {
    setState(() {
      _transactionsFuture = DatabaseManagement.instance.queryAllTransactions();
      _cardFuture = DatabaseManagement.instance.queryAllTransactions(); // อัปเดตข้อมูลสำหรับ CardDashBoard
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
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 50, 15, 0),
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
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
          child: Text(
            "Let's start accounting for expenses",
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 121, 121, 121),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: CardDashBoard(cardFuture: _cardFuture), // ส่ง Future สำหรับ CardDashBoard
        ),
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
          height: 250,
          child: CardFinancial(transactionsFuture: _transactionsFuture),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransaction()),
        );
        if (result == true) {
          _refreshData(); // รีเฟรชข้อมูลใหม่ทันทีหลังจากเพิ่มข้อมูลใหม่
        }
      },
      child: const Icon(Icons.add, size: 25,),
    ),
  );
}
