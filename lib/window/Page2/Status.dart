import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vongola/database/db_manage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Transaction_list.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String selectedPeriod = 'Day'; // ตัวแปรสำหรับเก็บค่าตัวเลือก
  DateTime currentDate = DateTime.now(); // วันที่ปัจจุบัน
  String? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('RECORD')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                selectedPeriod = value;
                selectedDate = null; // รีเซ็ต selectedDate
                if (value != 'Custom') {startDate = null; endDate = null;
                // เซ็ตให้เลือกปุ่มแรกของ GestureDetector
                if (selectedPeriod == 'Day') {
                  selectedDate = DateFormat('yyyy-MM-dd').format(currentDate); // ตั้งค่าเป็นวันที่ปัจจุบัน
                } else if (selectedPeriod == 'Month') {
                  selectedDate = DateFormat('yyyy-MM').format(DateTime(currentDate.year, currentDate.month)); // ตั้งค่าเป็นเดือนปัจจุบัน
                } else if (selectedPeriod == 'Year') {
                  selectedDate = currentDate.year.toString(); // ตั้งค่าเป็นปีปัจจุบัน
                }
              }

            });
              },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Day', child: Text('Day')),
                PopupMenuItem(value: 'Month', child: Text('Month')),
                PopupMenuItem(value: 'Year', child: Text('Year')),
                PopupMenuItem(value: 'Custom', child: Text('Custom')),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Custom date selection
          if (selectedPeriod == 'Custom') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green], // ไล่สีจากฟ้าไปเขียว
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Date Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Date:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                startDate != null
                                    ? DateFormat('yyyy-MM-dd').format(startDate!)
                                    : 'Select a date',
                                style: TextStyle(fontSize: 16, color: Colors.white70),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: Icon(Icons.calendar_today),
                                label: Text('Select Date'),
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null && picked != startDate) {
                                    setState(() {
                                      startDate = picked;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // สีปุ่มเป็นสีขาว
                                  foregroundColor: Colors.blue, // สีข้อความในปุ่ม
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16), // เพิ่มระยะห่างระหว่างสองคอลัมน์
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(endDate!)
                                    : 'Select a date',
                                style: TextStyle(fontSize: 16, color: Colors.white70),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: Icon(Icons.calendar_today),
                                label: Text('Select Date'),
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null && picked != endDate) {
                                    setState(() {
                                      endDate = picked;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // สีปุ่มเป็นสีขาว
                                  foregroundColor: Colors.green, // สีข้อความในปุ่ม
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Day, Month, Year selection
          if (selectedPeriod == 'Day') ...[
            Container(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 15, // 14 days before + 1 current day
                itemBuilder: (context, index) {
                  DateTime date = currentDate.subtract(Duration(days: 14 - index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM-dd').format(date);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM-dd').format(date);
                      });
                    },
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? Colors.pink[200] : Colors.pink[300],
                      ),
                      child: Text(
                        DateFormat('MMM d').format(date),
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
                itemCount: 15, // 14 months before + 1 current month
                itemBuilder: (context, index) {
                  DateTime monthDate = DateTime(currentDate.year, currentDate.month - (14 - index));
                  bool isSelected = selectedDate == DateFormat('yyyy-MM').format(monthDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = DateFormat('yyyy-MM').format(monthDate);
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
                itemCount: 5, // 5 years
                itemBuilder: (context, index) {
                  int year = currentDate.year - (4 - index);
                  bool isSelected = selectedDate == year.toString();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = year.toString();
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }
                return TransactionList(transactions: snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToCurrentDate() {
    // เลื่อนตำแหน่งไปที่วันปัจจุบัน
    if (selectedPeriod == 'Day') {
      _scrollController.animateTo(
        100.0 * 14, // ขนาดของแต่ละ item * index ของวันที่ปัจจุบัน
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Month') {
      _scrollController.animateTo(
        100.0 * 11, // ปรับให้ถูกต้องตามจำนวนเดือนที่แสดง
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (selectedPeriod == 'Year') {
      _scrollController.animateTo(
        100.0 * 4, // ปรับให้ตรงกับตำแหน่งปีปัจจุบัน
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await openDatabase('transaction.db');
    List<Map<String, dynamic>> results;
    print('Selected Date: $selectedDate');

    if (selectedPeriod == 'Day' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE Transactions.date_user LIKE ?',
          ['${selectedDate}%'] // ใช้ LIKE เพื่อรวมเวลา
      );
    } else if (selectedPeriod == 'Month' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE Transactions.date_user LIKE ?',
          ['${selectedDate}%']
      );
    } else if (selectedPeriod == 'Year' && selectedDate != null) {
      results = await db.rawQuery(
          'SELECT Transactions.*, Type_transaction.type_transaction '
              'FROM Transactions '
              'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
              'WHERE strftime("%Y", Transactions.date_user) = ?',
          [selectedDate]
      );
    } else if (selectedPeriod == 'Custom' && startDate != null && endDate != null) {
      results = await db.rawQuery(
        'SELECT Transactions.*, Type_transaction.type_transaction '
            'FROM Transactions '
            'JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction '
            'WHERE strftime(\'%Y-%m-%d\', Transactions.date_user) BETWEEN ? AND ?',
        [
          DateFormat('yyyy-MM-dd').format(startDate!),
          DateFormat('yyyy-MM-dd').format(endDate!),
        ],
      );}
    else {
      results = []; // คืนค่าลิสต์ว่างถ้าไม่มีการเลือก
    }

    for (var row in results) {
      print('Transaction: ${row['ID_type_transaction']}, Date: ${row['date_user']}, Amount: ${row['total_amount']}, Type: ${row['type_transaction']}');
      print('Amount: ${row['amount_transaction'] != null ? row['amount_transaction'] : 0}');
    }
    print(results);
    return results; // คืนค่าผลลัพธ์ที่ได้
  }
}