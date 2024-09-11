import 'package:flutter/material.dart';
import 'addBudget.dart';
import 'detailBudget.dart'; // เพิ่ม import สำหรับ detailBudget page
import '../../database/db_manage.dart'; // เพิ่ม import สำหรับ DatabaseManagement

class Budgetcatagory extends StatefulWidget {
  @override
  _Budgetcatagory createState() => _Budgetcatagory();
}

class _Budgetcatagory extends State<Budgetcatagory> {
  final DatabaseManagement _databaseManagement = DatabaseManagement.instance; // อินสแตนซ์ของ DatabaseManagement

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add budget category'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 20),
              children: [
                _buildBudgetItem('assets/food.png', "Food", 'Food'),
                _buildBudgetItem('assets/travel_expenses.png', "Travel expenses", 'Travel expenses'),
                _buildBudgetItem('assets/water_bill.png', "Water bill", 'Water bill'),
                _buildBudgetItem('assets/electricity_bill.png', "Electricity bill", 'Electricity bill'),
                _buildBudgetItem('assets/house.png', "House cost", 'House cost'),
                _buildBudgetItem('assets/car.png', "Car fare", 'Car fare'),
                _buildBudgetItem('assets/gasoline_cost.png', "Gasoline cost", 'Gasoline cost'),
                _buildBudgetItem('assets/medical.png', "Medical", 'Medical expenses'),
                _buildBudgetItem('assets/beauty.png', "Beauty", 'Beauty expenses'),
                _buildBudgetItem('assets/Other.png', "Other", 'Other'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String imagePath, String label, String valued) {
    return GestureDetector(
      onTap: () async {
        // ตรวจสอบข้อมูลก่อนนำทาง
        bool shouldNavigateToDetail = await _checkBudgetAvailability(valued);
        if (shouldNavigateToDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBudget(valued: valued), // ไปที่หน้า detailBudget
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBudget(valued: valued), // ไปที่หน้า AddBudget
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkBudgetAvailability(String valued) async {
    // ดึงข้อมูลจากฐานข้อมูล
    var budgets = await _databaseManagement.queryAllBudgets();

    for (var budget in budgets) {
      if (budget['ID_type_transaction'].toString() == valued) {
        DateTime dateEnd = DateTime.parse(budget['date_end']);
        if (DateTime.now().isBefore(dateEnd)) {
          return true; // ถ้าเวลาปัจจุบันยังไม่เกิน dateEnd
        }
      }
    }
    return false; // ถ้าเวลาปัจจุบันเกิน dateEnd หรือไม่มีข้อมูลที่ตรงกับ valued
  }
}


