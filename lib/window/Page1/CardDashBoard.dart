import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../database/db_manage.dart';
import '../Page2/page2.dart';

class CardDashBoard extends StatefulWidget {
  @override
  _CardDashBoardState createState() => _CardDashBoardState();
}

class _CardDashBoardState extends State<CardDashBoard> {
  double expensePercentage = 0.0;
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  String monthName = '';
  String year = '';

  @override
  void initState() {
    super.initState();
    _calculateExpensePercentage();
  }

  Future<void> _calculateExpensePercentage() async {
    
    DateTime now = DateTime.now(); 
    monthName = DateFormat('MMMM').format(now);
    year = DateFormat('yyyy').format(now);

    List<Map<String, dynamic>> transactions = await DatabaseManagement.instance.rawQuery(
      '''
      SELECT amount_transaction, type_expense FROM [Transactions]
      WHERE strftime('%m', date_user) = ? AND strftime('%Y', date_user) = ?
      ''',
      [DateFormat('MM').format(now), DateFormat('yyyy').format(now)]
    );

    if (transactions.isEmpty) {
      setState(() {
        totalIncome = 0.0;
        totalExpense = 0.0;
        expensePercentage = 0.0;
      });
      return;
    }

    for (var transaction in transactions) {
      double amount = transaction['amount_transaction'];
      bool isExpense = transaction['type_expense'] == 1; // Assuming 1 is for expense, 0 for income

      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
    }

    // Check 
    //print("Total Expense: $totalExpense, Total Income: $totalIncome"); 

    // Calculate expense percentage
    double percentage = (totalIncome > 0) ? (totalExpense / totalIncome) * 100 : 0;

    setState(() {
      expensePercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromARGB(255, 9, 209, 220), // Card color
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30), // Color when tapped
          child: SizedBox(
            width: 320, // Card width
            height: 130, // Card height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 12), 
                  child: Text(
                    'Summary for $monthName $year',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 16,
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Card(
                        color: Color.fromARGB(255, 235, 249, 255), // Card color
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: SizedBox(
                            width: 185, // Card width
                            height: 65, // Card height
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 53, 53, 53), 
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${totalIncome.toStringAsFixed(2)}', 
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿',
                                              style: TextStyle(
                                                color: const Color.fromARGB(255, 53, 53, 53),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${totalExpense.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
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
                        ),
                      ),
                    ),
                    SizedBox(width: 4),

                    Container(
                      padding: EdgeInsets.only(left: 0),
                      child: Card(
                        color: Color.fromARGB(255, 218, 244, 255),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: SizedBox(
                            width: 85,
                            height: 65,
                            child: Center(
                              child: Text(
                                '${expensePercentage.toStringAsFixed(0)} %',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 38, 38, 38),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
