import 'package:flutter/material.dart';
import 'budgetCatagory.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pageAddBudget.dart';
import 'detailBudget.dart'; // เพิ่ม import สำหรับ detailBudget page
import '../../database/db_manage.dart'; // เพิ่ม import สำหรับ DatabaseManagement
import 'budgetCompared.dart';

class Page4 extends StatefulWidget {
  @override
  _BugetPage createState() => _BugetPage();
}

class _BugetPage extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Budget'),
        ),
        elevation: 1.0, 
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217), // สีเส้นแบ่ง
            height: 1.0,
          ),
        ),
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
  
  //ลบข้อมูลในตาราง budget
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
                    _buildCategoryItem(context, 'assets/internet.png', "Internet", '5'),
                    _buildCategoryItem(context, 'assets/house.png', "House", '6'),
                    _buildCategoryItem(context, 'assets/car.png', "Car", '7'),
                    _buildCategoryItem(context, 'assets/gasoline_cost.png', "Gasoline", '8'),
                    _buildCategoryItem(context, 'assets/medical.png', "Medical", '9'),
                    _buildCategoryItem(context, 'assets/beauty.png', "Beauty", '10'),
                    _buildCategoryItem(context, 'assets/other.png', "Other", '11'),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // กำหนดขอบซ้ายขวา 20 หน่วย
            child: BudgetComparedList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, String imagePath, String label, String valued) {
    return GestureDetector(
      onTap: () async {
        bool shouldNavigateToDetail = await _checkBudgetAvailability(valued);
        if (shouldNavigateToDetail) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBudget(valued: valued),
            ),
          );
          
          if (result == true) {
            // รีเฟรช UI 
            setState(() {
            });
          }
        } else {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBudget(valued: valued),
            ),
          );
          
          if (result == true) {
            // รีเฟรช UI
            setState(() {
            });
          }
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
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Budgetcatagory()),
        );

        if (result == true) {
          setState(() {
            // รีเฟรชหน้าใหม่ที่นี่
          });
        }
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 240, 224, 253),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // สีเงา
                  offset: Offset(0, 3), // เงาเฉพาะด้านล่าง (แกน y)
                  blurRadius: 5, // กระจายของเงา
                  spreadRadius: 1, // ความกว้างของเงา
                ),
              ],
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: const Color.fromARGB(255, 75, 51, 111),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
