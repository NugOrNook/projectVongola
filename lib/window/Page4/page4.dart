import 'package:flutter/material.dart';
import 'budgetCatagory.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
              Flexible(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 120, // ความสูงของ Carousel
                    viewportFraction: 0.338, // ระยะห่างของแต่ละ item เทียบกับหน้าจอ
                    enableInfiniteScroll: false, // ปิดการ scroll แบบวน
                    // enlargeCenterPage: false, // ไม่ขยาย item ตรงกลาง
                    padEnds: false, // ปิดการ pad ขอบทั้งสองข้าง
                  ),
                  items: [
                    _buildCategoryItem('assets/food.png', "Food", 'Food'),
                    _buildCategoryItem('assets/travel_expenses.png', "Travel", 'Travel expenses'),
                    _buildCategoryItem('assets/water_bill.png', "Water", 'Water bill'),
                    _buildCategoryItem('assets/electricity_bill.png', "Electricity", 'Electricity bill'),
                    _buildCategoryItem('assets/house.png', "House", 'House cost'),
                    _buildCategoryItem('assets/car.png', "Car", 'Car fare'),
                    _buildCategoryItem('assets/gasoline_cost.png', "Gasoline", 'Gasoline cost'),
                    _buildCategoryItem('assets/medical.png', "Medical", 'Medical expenses'),
                    _buildCategoryItem('assets/beauty.png', "Beauty", 'Beauty expenses'),
                    _buildCategoryItem('assets/Other.png', "Other", 'Other'),
                  ],
                ),
              ),
              
              _buildAddButton(context), // ปุ่ม add ยังอยู่ในตำแหน่งเดิม
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
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String label, String valued) {
    return Column(
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
    );
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
