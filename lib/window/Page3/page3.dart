import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3IncomeState createState() => _Page3IncomeState();
}

class _Page3IncomeState extends State<Page3> {
  String selectedPeriod = 'Day';
  DateTime currentDate = DateTime.now();
  String? selectedDate;
  List<Map<String,dynamic>> transactionData = [];
  double totalIncome = 0.0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(currentDate); // กำหนดค่า selectedDate ก่อน
    fetchData(); // ดึงข้อมูลก่อน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate(); // เลื่อนไปยังวันที่ปัจจุบันหลังจากโหลด UI เสร็จ
    });
  }

  void _scrollToCurrentDate() {
    double itemWidth = 100.0; // กำหนดขนาดไอเท็ม
    if (selectedPeriod == 'Day') {
      int index = 14; // เริ่มต้นที่วันที่อยู่ฝั่งขวาสุด
      _scrollController.animateTo(
        itemWidth * index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Month') {
      int index = 14; // เดือนล่าสุด
      _scrollController.animateTo(
        itemWidth * index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Year') {
      int index = 4; // ปีล่าสุด
      _scrollController.animateTo(
        itemWidth * index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text('Income List'),
        ),
        elevation: 1.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217),
            height: 1.0,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedPeriod = value;
                if (selectedPeriod == 'Month') {
                  selectedDate = DateFormat('yyyy-MM').format(currentDate); // กำหนด selectedDate ให้เป็นเดือนล่าสุด
                } else if (selectedPeriod == 'Year') {
                  selectedDate = currentDate.year.toString(); // กำหนด selectedDate เป็นปีล่าสุด
                }
                fetchData(); // โหลดใหม่เลือกใหม่
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Day', child: Text('Day')),
                PopupMenuItem(value: 'Month', child: Text('Month')),
                PopupMenuItem(value: 'Year', child: Text('Year')),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/wallet_color.png',
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Total Income: ${totalIncome.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (selectedPeriod == 'Day') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (context, index) {
                  DateTime date = currentDate.subtract(Duration(days: 14 - index)); // สร้างวันใหม่ลบจำนวนวันตาม index จาก currentDate ทำให้ได้วันที่ย้อนหลัง
                  print(date);
                  print("****");
                  bool isSelected = selectedDate == DateFormat('yyyy-MM-dd').format(date);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM-dd').format(date);
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกวันที่
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink : Colors.pinkAccent,
                      ),
                      child: Text(
                        DateFormat('EEE d').format(date),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (selectedPeriod == 'Month') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (context, index) {
                  DateTime monthDate = DateTime(currentDate.year, currentDate.month - (14 - index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM').format(monthDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM').format(monthDate);
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกเดือน
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.greenAccent : Colors.green,
                      ),
                      child: Text(
                        DateFormat('MMM yyyy').format(monthDate),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (selectedPeriod == 'Year') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  int year = currentDate.year - (4-index);
                  bool isSelected = selectedDate == year.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = year.toString();
                        fetchData(); // เรียกฟังก์ชันเพื่อโหลดข้อมูลใหม่เมื่อเลือกปี
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink : Colors.pinkAccent,
                      ),
                      child: Text(
                        year.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Expanded(
            child: transactionData.isEmpty
                ? Center(
              child: Text(
                'No found data', // ข้อความเมื่อไม่มีข้อมูล
                style: TextStyle(fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: transactionData.length,
              itemBuilder: (context, index) {
                final transaction = transactionData[index];
                return ListTile(
                  title: Row(
                    children: [
                      // รูปภาพ wallet_color.png อยู่ทางซ้าย
                      Image.asset(
                        'assets/money.png',
                        width: 60, // ขนาดรูปภาพ
                        height: 60,
                      ),
                      SizedBox(width: 10), // ระยะห่างระหว่างรูปภาพกับข้อมูล
                      // ข้อมูลยอดเงินและวันที่อยู่ทางขวา
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat('d MMM yyyy').format(DateTime.parse(transaction['date_user']))}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '+ ${transaction['amount_transaction']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    final db = await openDatabase('transaction.db');
    List<Map<String, dynamic>> results;

    // คิวรีเพื่อดึงข้อมูลทั้งหมดจากตาราง Transactions
    results = await db.rawQuery('SELECT * FROM Transactions');

    if (selectedPeriod == 'Day' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE date_user LIKE ? AND type_expense = 0',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Month' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE date_user LIKE ? AND type_expense = 0',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Year' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT date_user, amount_transaction FROM Transactions '
              'WHERE strftime("%Y", date_user) = ? AND type_expense = 0 ',
          [selectedDate]
      );
    } else {
      results = []; // คืนค่าลิสต์ว่างถ้าไม่มีการเลือก
    }

    // อัปเดตยอดรวมรายได้ทั้งหมด
    double total = results.fold(0.0, (sum, item) => sum + (item['amount_transaction'] as double? ?? 0.0));

    setState(() {
      transactionData = results;
      print(results);
      totalIncome = total; // อัปเดตยอดรวมรายได้ทั้งหมด
    });
  }
}

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:vongola/database/db_manage.dart';
// import 'package:intl/intl.dart';

// class Page3 extends StatefulWidget {
//   @override
//   _Page3State createState() => _Page3State();
// }

// class _Page3State extends State<Page3> {
//   List<Map<String, dynamic>> income_transactions = [];
//   double totalIncome = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchTotal_income();
//   }

//   Future<void> _fetchTotal_income() async {
//     final List<Map<String, dynamic>> incomeResult = await DatabaseManagement.instance.rawQuery(
//       'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0',
//     );

//     if (incomeResult.isNotEmpty && incomeResult[0]['total_income'] != null) {
//       totalIncome = incomeResult[0]['total_income'];
//     }

//     _fetchStatus_income();
//   }

//   Future<void> _fetchStatus_income() async {
//     final List<Map<String, dynamic>> dailyTransactions = await DatabaseManagement.instance.rawQuery(
//       'SELECT * FROM transactions WHERE type_expense = 0',
//     );

//     setState(() {
//       income_transactions = dailyTransactions;
//     });
//   }

//   String _shortenMemo(String memo, {int maxLength = 10}) {
//     if (memo.length > maxLength) {
//       return memo.substring(0, maxLength) + '...';
//     }
//     return memo;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text('Wallet'),
//         ),
//         elevation: 1.0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: Container(
//             color: const Color.fromARGB(255, 217, 217, 217),
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 25),
//             Container(
//               padding: const EdgeInsets.all(15),
//               margin: EdgeInsets.only(left: 20, right: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: const Color.fromARGB(255, 231, 209, 201),
//               ),
//               child: Column(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         bottom: 0, 
//                         child: Container(
//                           width: 150, 
//                           height: 20,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.5),
//                                 blurRadius: 10,
//                                 offset: Offset(0, 5), 
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Image.asset(
//                         'assets/wallet_color.png',
//                         width: 150, 
//                         height: 150, 
//                         fit: BoxFit.contain, 
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 30,),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Income amount',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     height: 15,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Positioned(
//                           bottom: 0,
//                           left:  80,
//                           right: 80, 
//                           child: Container(
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '$totalIncome ฿',
//                               style: TextStyle(
//                                 fontSize: 25,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color.fromARGB(255, 33, 33, 33),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             SizedBox(height: 35),
//             ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: income_transactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = income_transactions[index];
//                 final DateTime date = DateTime.parse(transaction['date_user']);
//                 final String formattedDate = DateFormat('dd MMM yyyy').format(date);
//                 final String memo = transaction['memo_transaction'];

//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.green[20],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Image.asset(
//                             'assets/money.png',
//                             width: 40,
//                             height: 40,
//                             fit: BoxFit.cover,
//                           ),
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '$formattedDate',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   if (memo.isNotEmpty)
//                                     Text(
//                                       'Memo: ${_shortenMemo(memo)}',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                 ],
//                               ),
//                               Text(
//                                 '+ ${transaction['amount_transaction']}',
//                                 style: TextStyle(
//                                   color: Colors.green,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, right: 10),
//                       child: Divider(
//                         color: Colors.black12,
//                         height: 1,
//                         thickness: 0.5,
//                         indent: 20,
//                         endIndent: 20,
//                       ),
//                     )
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
