import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/transaction_model.dart';

// สร้าง class จัดการข้อมูล
class DatabaseManagement {
  
  static final DatabaseManagement instance = DatabaseManagement._init();  
  static Database? _database;                                             
  
  DatabaseManagement._init();

  Future<Database> get database async {
    if (_database != null) return _database!;                             
    _database = await _initDB('transaction.db');                          
    return _database!;                                                    
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();                          
    final path = join(dbPath, filePath);                              
    return await openDatabase(path, version: 1, onCreate: _createDB); 
  }

  Future _createDB(Database db, int version) async {
    final columnIdTransaction = 'ID_transaction';
    final columnDateUser = 'date_user';
    final columnAmountTransaction = 'amount_transaction';
    final columnTypeExpense = 'type_expense';
    final columnMemoTransaction = 'memo_transaction';

    final columnIdTypeTransaction = 'ID_type_transaction';
    final columnTypeTransaction = 'type_transaction';
  
    final columnIdBudget = 'ID_budget';
    final columnCapitalBudget = 'capital_budget';
    final columnDateStart = 'date_start';
    final columnDateEnd = 'date_end';
    
    await db.execute('''CREATE TABLE $tableTransaction (
      $columnIdTransaction INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnDateUser TEXT NOT NULL,
      $columnAmountTransaction REAL NOT NULL,
      $columnTypeExpense BOOLEAN NOT NULL,
      $columnMemoTransaction TEXT,
      $columnIdTypeTransaction INTEGER,    
      FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
    )''');

    await db.execute('''CREATE TABLE $tableBudget (
      $columnIdBudget INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnCapitalBudget REAL NOT NULL,
      $columnIdTypeTransaction INTEGER NOT NULL,
      $columnDateStart TEXT NOT NULL,
      $columnDateEnd TEXT NOT NULL,
      FOREIGN KEY ($columnIdTypeTransaction) REFERENCES $tableTypeTransaction ($columnIdTypeTransaction)
    )''');

    await db.execute('''CREATE TABLE $tableTypeTransaction (
      $columnIdTypeTransaction INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTypeTransaction TEXT NOT NULL
    )''');

    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Food' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Travel expenses' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Water bill' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Electricity bill' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'House cost' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Car fare' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Gasoline cost' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Cost of equipment' });
    await db.insert(tableTypeTransaction, { columnTypeTransaction: 'Other' });
  } 
 
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTransaction, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    Database db = await instance.database;
    return await db.query(tableTransaction);
  }

  Future<int> updateTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['ID_transaction'];
    return await db.update(tableTransaction, row, where: 'ID_transaction = ?', whereArgs: [id]);
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTransaction, where: 'ID_transaction = ?', whereArgs: [id]);
  }

  Future<int> insertBudget(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableBudget, row);
  }

  Future<List<Map<String, dynamic>>> queryAllBudgets() async {
    Database db = await instance.database;
    return await db.query(tableBudget);
  }

  Future<int> updateBudget(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['ID_budget'];
    return await db.update(tableBudget, row, where: 'ID_budget = ?', whereArgs: [id]);
  }

  Future<int> deleteBudget(int id) async {
    Database db = await instance.database;
    return await db.delete(tableBudget, where: 'ID_budget = ?', whereArgs: [id]);
  }

  Future<int> insertTypeTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableTypeTransaction, row);
  }

  Future<List<Map<String, dynamic>>> queryAllTypeTransactions() async {
    Database db = await instance.database;
    return await db.query(tableTypeTransaction);
  }

  Future<int> updateTypeTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['ID_type_transaction'];
    return await db.update(tableTypeTransaction, row, where: 'ID_type_transaction = ?', whereArgs: [id]);
  }

  Future<int> deleteTypeTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete(tableTypeTransaction, where: 'ID_type_transaction = ?', whereArgs: [id]);
  }


  Future<void> showAllData() async {
    Database db = await instance.database;

    // ดึงข้อมูลจากตาราง transaction
    List<Map<String, dynamic>> transactions = await db.query(tableTransaction);
    print('Transactions:');
    transactions.forEach((transaction) {
      print(transaction);
    });

    // ดึงข้อมูลจากตาราง budget
    List<Map<String, dynamic>> budgets = await db.query(tableBudget);
    print('Budgets:');
    budgets.forEach((budget) {
      print(budget);
    });

    // ดึงข้อมูลจากตาราง type_transaction
    List<Map<String, dynamic>> typeTransactions = await db.query(tableTypeTransaction);
    print('Type Transactions:');
    typeTransactions.forEach((typeTransaction) {
      print(typeTransaction);
    });
  }

  Future<int?> getTypeTransactionId(String category) async {
    Database db = await DatabaseManagement.instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'type_transaction',
      columns: ['ID_type_transaction'],
      where: 'type_transaction = ?',
      whereArgs: [category],
    );

    if (results.isNotEmpty) {
      return results.first['ID_type_transaction'];
    }
    return null;
  }
}