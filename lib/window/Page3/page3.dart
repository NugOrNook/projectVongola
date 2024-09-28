import 'package:flutter/material.dart';
import 'package:vongola/database/db_manage.dart';
import 'package:intl/intl.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, dynamic>> income_transactions = [];
  double totalIncome = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotal_income();
  }

  Future<void> _fetchTotal_income() async {
    final List<Map<String, dynamic>> incomeResult = await DatabaseManagement.instance.rawQuery(
      'SELECT SUM(amount_transaction) AS total_income FROM transactions WHERE type_expense = 0',
    );

    if (incomeResult.isNotEmpty && incomeResult[0]['total_income'] != null) {
      totalIncome = incomeResult[0]['total_income'];
    }

    _fetchStatus_income();
  }

  Future<void> _fetchStatus_income() async {
    final List<Map<String, dynamic>> dailyTransactions = await DatabaseManagement.instance.rawQuery(
      'SELECT * FROM transactions WHERE type_expense = 0',
    );

    setState(() {
      income_transactions = dailyTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.brown[200],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 90.0),
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/wallet_color.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'remaining balance\n',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '$totalIncome'' ฿\n',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: income_transactions.length,
              itemBuilder: (context, index) {
                final transaction = income_transactions[index];
                final DateTime date = DateTime.parse(transaction['date_user']);
                final String formattedDate = DateFormat('dd MMM yyyy').format(date); // เปลี่ยนที่นี่

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.green[20],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            'assets/money.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$formattedDate',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Memo: ${transaction['memo_transaction']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(
                                '+ ${transaction['amount_transaction']}',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider( // เพิ่ม Divider ที่นี่
                      color: Colors.black12,
                      height: 1,
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}