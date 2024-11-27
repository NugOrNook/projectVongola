import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'budgetCatagory.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pageAddBudget.dart';
import 'detailBudget.dart';
import '../../database/db_manage.dart';
import 'budgetCompared.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Page4 extends StatefulWidget {
  @override
  _BugetPage createState() => _BugetPage();
}

class _BugetPage extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:Center(child: Text(localizations.budget)),
        elevation: 500.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade200, Color(0xFEF7FFFF)], // ไล่สีพื้นหลัง
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                    _buildCategoryItem(context, 'assets/food.png', localizations.food, '1'),
                    _buildCategoryItem(context, 'assets/travel_expenses.png', localizations.travelexpenses, '2'),
                    _buildCategoryItem(context, 'assets/water_bill.png', localizations.waterbill, '3'),
                    _buildCategoryItem(context, 'assets/electricity_bill.png', localizations.electricitybill, '4'),
                    _buildCategoryItem(context, 'assets/internet.png', localizations.internetcost, '5'),
                    _buildCategoryItem(context, 'assets/house.png', localizations.housecost, '6'),
                    _buildCategoryItem(context, 'assets/car.png', localizations.carfare, '7'),
                    _buildCategoryItem(context, 'assets/gasoline_cost.png', localizations.gasolinecost, '8'),
                    _buildCategoryItem(context, 'assets/medical.png', localizations.medicalexpenses, '9'),
                    _buildCategoryItem(context, 'assets/beauty.png', localizations.beautyexpenses, '10'),
                    _buildCategoryItem(context, 'assets/other.png', localizations.other, '11'),
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
          child: AutoSizeText(
            localizations.showbudget,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            maxLines: 1,
            minFontSize: 10,
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
                Flexible(
                  child: AutoSizeText(
                    label,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    minFontSize: 10,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkBudgetAvailability(String valued) async {
    var budgets = await _databaseManagement.queryAllBudgets();

    for (var budget in budgets) {
      if (budget['ID_type_transaction'].toString() == valued) {
        DateTime dateEnd = DateTime.parse(budget['date_end']);
        if (DateTime.now().isBefore(dateEnd)) {
          return true;
        }
      }
    }
    return false;
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
              color: Colors.red.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 30,
              color: Colors.red.shade800,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}