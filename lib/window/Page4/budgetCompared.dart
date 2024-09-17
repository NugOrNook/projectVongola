import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // สำหรับจัดการวันที่
import '../../database/db_manage.dart'; // นำเข้า class DatabaseManagement ของคุณ

class BudgetComparedList extends StatelessWidget {
  
  Future<List<Map<String, dynamic>>> fetchBudgetData() async {
    final db = DatabaseManagement.instance;
    final now = DateTime.now();
    final formattedNow = DateFormat('yyyy-MM-dd').format(now);

    // ดึง budget ที่วันปัจจุบันยังไม่เกิน columnDateEnd
    final budgets = await db.queryAllBudgets();
    List<Map<String, dynamic>> filteredBudgets = [];

    for (var budget in budgets) {
      if (DateTime.parse(budget['date_end']).isAfter(now)) {
        // ดึง balance (ผลรวมของ transaction ในช่วงเวลาที่กำหนด)
        final transactions = await db.queryAllTransactions();
        double balance = 0.0;
        for (var transaction in transactions) {
          if (transaction['ID_type_transaction'] == budget['ID_type_transaction']) {
            final transactionDate = DateTime.parse(transaction['date_user']);
            if (transactionDate.isAfter(DateTime.parse(budget['date_start'])) &&
                transactionDate.isBefore(DateTime.parse(budget['date_end']))) {
              balance += transaction['amount_transaction'];
            }
          }
        }

        final double budgetAmount = budget['capital_budget'];
        final double progress = budgetAmount > 0 ? balance / budgetAmount : 0.0;

        filteredBudgets.add({
          'idTypeTransaction': budget['ID_type_transaction'],
          'budget': budgetAmount,
          'balance': balance,
          'progress': progress,
        });
      }
    }

    return filteredBudgets;
  }

  // ฟังก์ชันแมป idTypeTransaction กับ imagePath
  String getImagePath(int idTypeTransaction) {
    switch (idTypeTransaction) {
      case 1:
        return 'assets/food.png';
      case 2:
        return 'assets/travel_expenses.png';
      case 3:
        return 'assets/water_bill.png';
      case 4:
        return 'assets/electricity_bill.png';
      case 5:
        return 'assets/house.png';
      case 6:
        return 'assets/car.png';
      case 7:
        return 'assets/gasoline_cost.png';
      case 8:
        return 'assets/medical.png';
      case 9:
        return 'assets/beauty.png';
      case 10:
        return 'assets/Other.png';
      default:
        return 'assets/Other.png'; // กรณีที่ไม่มีการแมป
    }
  }

  String getText(int idTypeTransaction) {
    switch (idTypeTransaction) {
      case 1:
        return 'Food';
      case 2:
        return 'Travel';
      case 3:
        return 'Water';
      case 4:
        return 'Electricity';
      case 5:
        return 'House';
      case 6:
        return 'Car';
      case 7:
        return 'Gasoline';
      case 8:
        return 'Medical';
      case 9:
        return 'Beauty';
      case 10:
        return 'Other';
      default:
        return 'Other'; // กรณีที่ไม่มีการแมป
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBudgetData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final budgetList = snapshot.data!;

        return ListView.builder(
          itemCount: budgetList.length,
          itemBuilder: (context, index) {
            final budgetData = budgetList[index];
            final double budget = budgetData['budget'];
            final double balance = budgetData['balance'];
            final double progress = budgetData['progress'];
            final int idTypeTransaction = budgetData['idTypeTransaction'];

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(255, 217, 217, 217),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Image.asset(
                      getImagePath(idTypeTransaction), // ใช้ฟังก์ชัน getImagePath เพื่อดึงรูปภาพที่ต้องการ
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getText(idTypeTransaction),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Budget: ${budget.toStringAsFixed(0)} ฿'),
                        Text('Balance: ${balance.toStringAsFixed(0)} ฿'),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progress > 0.8 ? Colors.red : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
