import 'dart:ui';
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

  String _shortenMemo(String memo, {int maxLength = 10}) {
    if (memo.length > maxLength) {
      return memo.substring(0, maxLength) + '...';
    }
    return memo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Wallet'),
        ),
        elevation: 1.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(15),
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 231, 209, 201),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 0, 
                        child: Container(
                          width: 150, 
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 5), 
                              ),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/wallet_color.png',
                        width: 150, 
                        height: 150, 
                        fit: BoxFit.contain, 
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Income amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 15,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 0,
                          left:  80,
                          right: 80, 
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$totalIncome ฿',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 33, 33, 33),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 35),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: income_transactions.length,
              itemBuilder: (context, index) {
                final transaction = income_transactions[index];
                final DateTime date = DateTime.parse(transaction['date_user']);
                final String formattedDate = DateFormat('dd MMM yyyy').format(date);
                final String memo = transaction['memo_transaction'];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[20],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            'assets/money.png',
                            width: 40,
                            height: 40,
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  if (memo.isNotEmpty)
                                    Text(
                                      'Memo: ${_shortenMemo(memo)}',
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
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        color: Colors.black12,
                        height: 1,
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                      ),
                    )
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
