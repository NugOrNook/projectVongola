import 'package:flutter/material.dart';
import 'budgetCatagory.dart';

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

class CreateBudget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryItem('assets/house.png', "House cost"),
              _buildCategoryItem('assets/car.png', "Car fare"),
              _buildCategoryItem('assets/water_bill.png', "Water bill"),
              _buildAddButton(context),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20, left: 20, bottom: 20), // กำหนดเฉพาะด้านบน
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
              _buildBudgetItem('assets/food.png', "Food", 2000, 1250),
              _buildBudgetItem('assets/car.png', "Car fare", 1500, 950),
              _buildBudgetItem('assets/personal.png', "Personal Item", 2000, 1200),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String label) {
    return Column(
      children: [
        Container(
          height: 95,
          width: 75,
          margin: EdgeInsets.all(8), // ระยะห่างจากกรอบรอบนอก
          padding: EdgeInsets.symmetric(vertical: 16), // ระยะห่างจากขอบกล่องในแนวตั้ง
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255), // พื้นหลังสีเทาอ่อน
            border: Border.all(
              color: const Color.fromARGB(255, 217, 217, 217), // ขอบสีเทาเข้มเล็กน้อย
              width: 1, // ความกว้างของขอบ
            ),
            borderRadius: BorderRadius.circular(8), // ขอบมนของกล่อง
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
                width: 35, // กำหนดขนาดของรูปภาพ
                height: 35,
              ),
              SizedBox(height: 9), // ระยะห่างระหว่างรูปภาพและข้อความ
              Text(
                label,
                style: TextStyle(
                  fontSize: 12, // ขนาดของตัวอักษร
                ),
                textAlign: TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
                softWrap: true, // อนุญาตให้ตัดคำอัตโนมัติ
                maxLines: 2, // จำกัดจำนวนบรรทัดสูงสุดเป็น 2 บรรทัด
                overflow: TextOverflow.ellipsis, // ถ้าข้อความยาวเกินจะใส่ "..." 
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () async { 
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Budgetcatagory()),
        );
        // รีเฟรชข้อมูลเมื่อกลับมาจากหน้า Addbudgetcatagory
      },
      child: Column(
        children: [
          Container(
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
          color: const Color.fromARGB(255, 217, 217, 217), // ขอบสีเทาเข้มเล็กน้อย
          width: 1, // ความกว้างของขอบ
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
                  color: progress > 0.5 ? Colors.blue : Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
