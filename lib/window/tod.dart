import 'package:flutter/material.dart';
import 'pageAddLog.dart';
import '../database/db_manage.dart';



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
            //Text Introduction
            Container(
              padding: EdgeInsets.fromLTRB(45, 80, 15, 0), // จัดตำแหน่ง ซ้าย บน ขวา ล่าง
              child: Text(
                'Hello, Friend!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(45, 0, 15, 5),
              child: Text(
                "Let's start accounting for expenses",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 85, 85, 85),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Card DashBoard
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0), // ระยะห่างบนและล่างของ Card
              child: CardDashBoard(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(45, 20, 15, 5),
              child: Text(
                "Budget in each category",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: CardFinancial(
                transactionsFuture: _transactionsFuture,
              ), // ส่ง Future ให้กับ CardFinancial
            ),
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
          child: const Icon(Icons.add),
        ),
      );
}

class CardDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromARGB(255, 42, 184, 250), // กำหนดสีของ Card
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30), // สีเมื่อกด
          onTap: () {
            // ฟังก์ชันที่เรียกเมื่อมีการกด
            debugPrint('Card tapped.'); // แสดงข้อความใน console เมื่อกด
          },
          child: SizedBox(
            width: 320, // ความกว้างของ Card
            height: 120, // ความสูงของ Card
            child: Center(
              // จัดข้อความให้อยู่ตรงกลาง
              child: Text(
                'A card that can be tapped',
                style: TextStyle(
                  color: Colors.white, // กำหนดสีของข้อความ
                  fontSize: 18, // ขนาดของข้อความ
                  fontWeight: FontWeight.bold, // ทำให้ข้อความหนา
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardFinancial extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> transactionsFuture;

  CardFinancial({required this.transactionsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: transactionsFuture, // ใช้ Future จากการส่งค่า
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No transactions found.'));
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            return ListTile(
              title: Text('Amount: \$${transaction['amount_transaction']}'),
              subtitle: Text(
                'Date: ${transaction['date_user']}\n'
                'Memo: ${transaction['memo_transaction'] ?? 'No memo'}',
              ),
              trailing: transaction['type_expense'] == 1 // แปลงค่า int เป็น bool
                  ? Icon(Icons.arrow_downward, color: Colors.green) // แสดง icon แสดงเป็นรายจ่าย
                  : Icon(Icons.arrow_upward, color: Colors.red), // แสดง icon แสดงเป็นรายรับ
            );
          },
        );
      },
    );
  }
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

//----------------------------------------------------------------






// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../model/transaction_model.dart';

// // สร้าง class จัดการข้อมูล
// class DatabaseManagement {
  
//   static final DatabaseManagement instance = DatabaseManagement._init();  
//   static Database? _database;                                             
  
//   DatabaseManagement._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;                             
//     _database = await _initDB('transaction.db');                          
//     return _database!;                                                    
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();                          
//     final path = join(dbPath, filePath);                              
//     return await openDatabase(path, version: 1, onCreate: _createDB); 
//   }


//   Future _createDB(Database db, int version) async {
//     final columnIdTransaction = 'ID_transaction';
//     final columnDateUser = 'date_user';
//     final columnAmountTransaction = 'amount_transaction';
//     final columnTypeExpense = 'type_expense';
//     final columnMemoTransaction = 'memo_transaction';

//     final columnIdTypeTransaction = 'ID_type_transaction';
//     final columnTypeTransaction = 'type_transaction';
  
//     final columnIdBudget = 'ID_budget';
//     final columnCapitalBudget = 'capital_budget';
//     final columnDateStart = 'date_start';
//     final columnDateEnd = 'date_end';
    
//     await db.execute('''CREATE TABLE $tableTransaction (
//       $columnIdTransaction INTEGER PRIMARY KEY AUTOINCREMENT, 
//       $columnDateUser TEXT NOT NULL,
//       $columnAmountTransaction REAL NOT NULL,
//       $columnTypeExpense BOOLEAN NOT NULL,
//       $columnMemoTransaction TEXT,
//       $columnIdTypeTransaction INTEGER,    
//       FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
//     )''');

//     await db.execute('''CREATE TABLE $tableBudget (
//       $columnIdBudget INTEGER PRIMARY KEY AUTOINCREMENT,
//       $columnCapitalBudget REAL NOT NULL,
//       $columnIdTypeTransaction INTEGER NOT NULL,
//       $columnDateStart TEXT NOT NULL,
//       $columnDateEnd TEXT NOT NULL,
//       FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
//     )''');

//     await db.execute('''CREATE TABLE $tableTypeTransaction (
//       $columnIdTypeTransaction INTEGER PRIMARY KEY AUTOINCREMENT,
//       $columnTypeTransaction TEXT NOT NULL
//     )''');

//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Food' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Travel expenses' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Water bill' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Electricity bill' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'House cost' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Car fare' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Gasoline cost' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Cost of equipment' });
//     await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Other' });
//   } 

 

//   Future<int> insertTransaction(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(tableTransaction, row);
//   }

//   Future<List<Map<String, dynamic>>> queryAllTransactions() async {
//     Database db = await instance.database;
//     return await db.query(tableTransaction);
//   }

//   Future<int> updateTransaction(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row['ID_transaction'];
//     return await db.update(tableTransaction, row, where: 'ID_transaction = ?', whereArgs: [id]);
//   }

//   Future<int> deleteTransaction(int id) async {
//     Database db = await instance.database;
//     return await db.delete(tableTransaction, where: 'ID_transaction = ?', whereArgs: [id]);
//   }

//   Future<int> insertBudget(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(tableBudget, row);
//   }

//   Future<List<Map<String, dynamic>>> queryAllBudgets() async {
//     Database db = await instance.database;
//     return await db.query(tableBudget);
//   }

//   Future<int> updateBudget(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row['ID_budget'];
//     return await db.update(tableBudget, row, where: 'ID_budget = ?', whereArgs: [id]);
//   }

//   Future<int> deleteBudget(int id) async {
//     Database db = await instance.database;
//     return await db.delete(tableBudget, where: 'ID_budget = ?', whereArgs: [id]);
//   }

//   Future<int> insertTypeTransaction(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(tableTypeTransaction, row);
//   }

//   Future<List<Map<String, dynamic>>> queryAllTypeTransactions() async {
//     Database db = await instance.database;
//     return await db.query(tableTypeTransaction);
//   }

//   Future<int> updateTypeTransaction(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row['ID_type_transaction'];
//     return await db.update(tableTypeTransaction, row, where: 'ID_type_transaction = ?', whereArgs: [id]);
//   }

//   Future<int> deleteTypeTransaction(int id) async {
//     Database db = await instance.database;
//     return await db.delete(tableTypeTransaction, where: 'ID_type_transaction = ?', whereArgs: [id]);
//   }


//   Future<void> showAllData() async {
//     Database db = await instance.database;

//     // ดึงข้อมูลจากตาราง transaction
//     List<Map<String, dynamic>> transactions = await db.query(tableTransaction);
//     print('Transactions:');
//     transactions.forEach((transaction) {
//       print(transaction);
//     });

//     // ดึงข้อมูลจากตาราง budget
//     List<Map<String, dynamic>> budgets = await db.query(tableBudget);
//     print('Budgets:');
//     budgets.forEach((budget) {
//       print(budget);
//     });

//     // ดึงข้อมูลจากตาราง type_transaction
//     List<Map<String, dynamic>> typeTransactions = await db.query(tableTypeTransaction);
//     print('Type Transactions:');
//     typeTransactions.forEach((typeTransaction) {
//       print(typeTransaction);
//     });
//   }

//   Future<int?> getTypeTransactionId(String category) async {
//     Database db = await DatabaseManagement.instance.database;
//     List<Map<String, dynamic>> results = await db.query(
//       'type_transaction',
//       columns: ['ID_type_transaction'],
//       where: 'type_transaction = ?',
//       whereArgs: [category],
//     );

//     if (results.isNotEmpty) {
//       return results.first['ID_type_transaction'];
//     }
//     return null;
//   }
// }