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





















// import 'package:flutter/material.dart';
// import 'pageAddLog.dart';
// import '../database/db_manage.dart';

// class Page1 extends StatefulWidget {
//   @override
//   _Introduction createState() => _Introduction();
// }

// class _Introduction extends State<Page1> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,           // จัดตำแหน่ง widgets ให้อยู่ที่ด้านซ้าย
//       children: <Widget>[

//         //Text Introduction
//         Container(
//           padding: EdgeInsets.fromLTRB(45, 80, 15, 0),        // จัดตำแหน่ง ซ้าย บน ขวา ล่าง
//           child: Text(
//             'Hello, Friend!', 
//             style: TextStyle(
//               fontSize: 30, 
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),

//         Container(
//           padding: EdgeInsets.fromLTRB(45, 0, 15, 5),
//           child: Text(
//             "Let's start accounting for expenses", 
//             style: TextStyle(
//               fontSize: 16, 
//               color: const Color.fromARGB(255, 85, 85, 85), 
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),

//         //Card DashBoard
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 20.0), // ระยะห่างบนและล่างของ Card
//           child: CardDashBoard(),
//         ),

//         Container(
//           padding: EdgeInsets.fromLTRB(45, 20, 15, 5),
//           child: Text(
//             "Budget in each category", 
//             style: TextStyle(
//               fontSize: 20, 
//               color: Colors.black,         
//             ),
//           ),
//         ),

//         Expanded(
//           child: CardFinancial(), // เปลี่ยน CardFinancial ให้แสดงใน Expanded เพื่อขยายให้เต็มที่ใน Column
//         ),
//       ],
//     ), 

//     //ปุ่มไปยังหน้าบันทึกรายรายจ่าย
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransaction()),); // เปลี่ยนเป็นหน้าใหม่ที่คุณต้องการ
//       },
//       child: const Icon(Icons.add),
//     ),
//   );
// }

// class CardDashBoard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         color: Color.fromARGB(255, 42, 184, 250), // กำหนดสีของ Card
//         clipBehavior: Clip.hardEdge,
//         child: InkWell(
//           splashColor: Colors.blue.withAlpha(30), // สีเมื่อกด
//           onTap: () { // ฟังก์ชันที่เรียกเมื่อมีการกด
//             debugPrint('Card tapped.'); // แสดงข้อความใน console เมื่อกด
//           },
//           child: SizedBox(
//             width: 320, // ความกว้างของ Card
//             height: 120, // ความสูงของ Card
//             child: Center( // จัดข้อความให้อยู่ตรงกลาง
//               child: Text(
//                 'A card that can be tapped', 
//                 style: TextStyle(
//                   color: Colors.white, // กำหนดสีของข้อความ
//                   fontSize: 18, // ขนาดของข้อความ
//                   fontWeight: FontWeight.bold, // ทำให้ข้อความหนา
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardFinancial extends StatefulWidget {
//   @override
//   _CardFinancialState createState() => _CardFinancialState();
// }

// class _CardFinancialState extends State<CardFinancial> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: DatabaseManagement.instance.queryAllTransactions(), // เรียกข้อมูลจาก database
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No transactions found.'));
//         }

//         final transactions = snapshot.data!;

//         return ListView.builder(
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             final transaction = transactions[index];

//             return ListTile(
//               title: Text('Amount: \$${transaction['amount_transaction']}'),
//               subtitle: Text(
//                 'Date: ${transaction['date_user']}\n'
//                 'Memo: ${transaction['memo_transaction'] ?? 'No memo'}',
//               ),
//               trailing: transaction['type_expense'] == 1  // แปลงค่า int เป็น bool
//                 ? Icon(Icons.arrow_downward, color: Colors.red) // แสดง icon แสดงเป็นรายจ่าย
//                 : Icon(Icons.arrow_upward, color: Colors.green), // แสดง icon แสดงเป็นรายรับ
//               );

//           },
//         );
//       },
//     );
//   }
// }