import 'package:flutter/material.dart';
import 'budgetCatagory.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pageAddBudget.dart';
import 'detailBudget.dart'; // เพิ่ม import สำหรับ detailBudget page
import '../../database/db_manage.dart'; // เพิ่ม import สำหรับ DatabaseManagement

import 'show.dart';

class Page4 extends StatefulWidget {
  @override
  _BugetPage createState() => _BugetPage();
}

class _BugetPage extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Management'),
      ),
      body: CreateBudget(),
    );
  }
}

class CreateBudget extends StatefulWidget {
  @override
  _CreateBudgetState createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  final DatabaseManagement _databaseManagement = DatabaseManagement.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   // เรียกใช้ฟังก์ชันลบข้อมูลทุกครั้งที่หน้าแอปถูกโหลด
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     clearAllBudgets();
  //   });
  // }

  // void clearAllBudgets() async {
  //   int result = await _databaseManagement.deleteAllBudgets();
  //   if (result > 0) {
  //     print('ลบข้อมูลทั้งหมดในตาราง budget สำเร็จ');
  //   } else {
  //     print('ไม่มีข้อมูลในตาราง budget ที่จะลบ');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 120,
                    viewportFraction: 0.338,
                    enableInfiniteScroll: false,
                    padEnds: false,
                  ),
                  items: [
                    _buildCategoryItem(context, 'assets/food.png', "Food", '1'),
                    _buildCategoryItem(context, 'assets/travel_expenses.png', "Travel", '2'),
                    _buildCategoryItem(context, 'assets/water_bill.png', "Water", '3'),
                    _buildCategoryItem(context, 'assets/electricity_bill.png', "Electricity", '4'),
                    _buildCategoryItem(context, 'assets/house.png', "House", '5'),
                    _buildCategoryItem(context, 'assets/car.png', "Car", '6'),
                    _buildCategoryItem(context, 'assets/gasoline_cost.png', "Gasoline", '7'),
                    _buildCategoryItem(context, 'assets/medical.png', "Medical", '8'),
                    _buildCategoryItem(context, 'assets/beauty.png', "Beauty", '9'),
                    _buildCategoryItem(context, 'assets/Other.png', "Other", '10'),
                  ],
                ),
              ),
              _buildAddButton(context),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 0, left: 20, bottom: 20),
          child: Text(
            "Budget in each category",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
            children: [
              _buildBudgetItem('assets/food.png', "Food", 2000, 1850),
              _buildBudgetItem('assets/car.png', "Car fare", 1500, 950),
              _buildBudgetItem('assets/beauty.png', "Beauty", 2000, 100),
            ],
          ),
        ),
        // Expanded(
        //   child: BudgetList(), // ใช้ BudgetList แทน ListView
        // ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, String imagePath, String label, String valued) {
    return GestureDetector(
      onTap: () async {
        bool shouldNavigateToDetail = await _checkBudgetAvailability(valued);
        if (shouldNavigateToDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBudget(valued: valued),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBudget(valued: valued),
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            height: 95,
            width: 75,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              border: Border.all(
                color: const Color.fromARGB(255, 217, 217, 217),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  width: 35,
                  height: 35,
                ),
                SizedBox(height: 9),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkBudgetAvailability(String valued) async {
    // ดึงข้อมูลจากฐานข้อมูลเพื่อตรวจสอบงบประมาณ
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

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Budgetcatagory()),
        );
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 224, 252, 255),
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String imagePath, String label, double budget, double balance) {
    double progress = balance / budget;

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
              imagePath,
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
                  label,
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
  }
}
