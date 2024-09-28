import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:async';
import '../../database/db_manage.dart'; // Importing DatabaseManagement
import '../Page2/page2.dart';

class CardDashBoard extends StatefulWidget {
  @override
  _CardDashBoardState createState() => _CardDashBoardState();
}

class _CardDashBoardState extends State<CardDashBoard> {
  double expensePercentage = 0.0;
  double totalExpense = 0.0; // Declare totalExpense as an instance variable
  double totalIncome = 0.0; // Declare totalIncome as an instance variable
  String monthName = ''; // To store month name
  String year = ''; // To store year

  @override
  void initState() {
    super.initState();
    _calculateExpensePercentage();
  }

  // Function to calculate expense percentage
  Future<void> _calculateExpensePercentage() async {
    // Get the current month and year
    DateTime now = DateTime.now(); // Get current date
    monthName = DateFormat('MMMM').format(now); // Get the full month name
    year = DateFormat('yyyy').format(now); // Get the current year

    // Query expense and income data from the database
    List<Map<String, dynamic>> transactions = await DatabaseManagement.instance.rawQuery(
      '''
      SELECT amount_transaction, type_expense FROM [Transactions]
      WHERE strftime('%m', date_user) = ? AND strftime('%Y', date_user) = ?
      ''',
      [DateFormat('MM').format(now), DateFormat('yyyy').format(now)]
    );

    // Check if transactions are empty to avoid errors
    if (transactions.isEmpty) {
      setState(() {
        totalIncome = 0.0;
        totalExpense = 0.0;
        expensePercentage = 0.0;
      });
      return;
    }

    // Calculate income and expenses
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page2()),
            );
          },
          child: SizedBox(
            width: 320, // Card width
            height: 130, // Card height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 12), // Adjust padding for position
                  child: Text(
                    'Summary for $monthName $year', // Updated to show current month and year
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 16, // Text size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Adding Row for the two Cards
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Card(
                        color: Color.fromARGB(255, 209, 241, 255), // Card color
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: SizedBox(
                            width: 85, // Card width
                            height: 65, // Card height
                            child: Center(
                              child: Text(
                                '${expensePercentage.toStringAsFixed(0)} %', // Display calculated percentage
                                style: TextStyle(
                                  fontSize: 24, // Font size
                                  fontWeight: FontWeight.bold, // Bold
                                  color: const Color.fromARGB(255, 38, 38, 38), // Text color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4), // Spacing between the two cards

                    Container(
                      padding: EdgeInsets.only(left: 0),
                      child: Card(
                        color: Color.fromARGB(255, 235, 249, 255), // Card color
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: SizedBox(
                            width: 185, // Card width
                            height: 65, // Card height
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12), // Padding for the inner content
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // Center align the inner content
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 53, 53, 53), // Text color
                                          fontSize: 14, // Text size
                                          fontWeight: FontWeight.bold, // Bold text
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${totalIncome.toStringAsFixed(2)}', // Income amount
                                              style: TextStyle(
                                                color: Colors.green, // Color for totalIncome
                                                fontSize: 14, // Font size
                                                fontWeight: FontWeight.bold, // Bold text
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿', // Currency symbol
                                              style: TextStyle(
                                                color: const Color.fromARGB(255, 53, 53, 53), // Text color
                                                fontSize: 14, // Font size
                                                fontWeight: FontWeight.bold, // Bold text
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
                                          color: Colors.black, // Text color
                                          fontSize: 14, // Text size
                                          fontWeight: FontWeight.bold, // Bold text
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${totalExpense.toStringAsFixed(2)}', // Expense amount
                                              style: TextStyle(
                                                color: Colors.red, // Color for totalExpense
                                                fontSize: 14, // Font size
                                                fontWeight: FontWeight.bold, // Bold text
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿', // Currency symbol
                                              style: TextStyle(
                                                color: Colors.black, // Color for currency symbol
                                                fontSize: 14, // Font size
                                                fontWeight: FontWeight.bold, // Bold text
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
