import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'addBudget.dart';

class Budgetcatagory extends StatefulWidget {
  @override
  _Budgetcatagory createState() => _Budgetcatagory();
}

class _Budgetcatagory extends State<Budgetcatagory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add budget catecory'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ปิดหน้า AddTransaction และย้อนกลับไปที่หน้าเดิม
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 20),
              children: [
                _buildBudgetItem('assets/food.png', "Food", '0'),
                _buildBudgetItem('assets/travel_expenses.png', "Travel expenses", '1'),
                _buildBudgetItem('assets/personal.png', "Water bill", '2'),
                _buildBudgetItem('assets/electricity_bill.png', "Electricity bill", '3'),
                _buildBudgetItem('assets/house.png', "House cost", '4'),
                _buildBudgetItem('assets/car.png', "Car fare", '5'),
                _buildBudgetItem('assets/gasoline_cost.png', "Gasoline cost", '6'),
                _buildBudgetItem('assets/personal.png', "Cost of equipment", '7'),
                _buildBudgetItem('assets/Other.png', "Other",'8'),   
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String imagePath, String label, String valued) {
    return GestureDetector(
      onTap: () {
        // เมื่อกดที่รายการ ให้เปิดหน้าใหม่พร้อมส่งค่า valued ไปด้วย
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBudget(valued: valued),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 217, 217, 217), // ขอบสีเทาเข้มเล็กน้อย
            width: 1, // ความกว้างของขอบ
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

}

