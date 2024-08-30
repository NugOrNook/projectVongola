import 'package:flutter/material.dart';

class CardFinancial extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> transactionsFuture;

  CardFinancial({required this.transactionsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: transactionsFuture, // ใช้ Future จากการส่งค่า
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No transactions found.'));
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];

            return ListTile(
              title: Text('Amount: \$${transaction['amount_transaction']}'),
              subtitle: Text(
                'Date: ${transaction['date_user']}\n'
                'Memo: ${transaction['memo_transaction'] ?? 'No memo'}',
              ),
              trailing: transaction['type_expense'] == 1 // แปลงค่า int เป็น bool
                  ? Icon(Icons.arrow_downward, color: Colors.red) // แสดง icon แสดงเป็นรายจ่าย
                  : Icon(Icons.arrow_upward, color: Colors.green), // แสดง icon แสดงเป็นรายรับ
            );
          },
        );
      },
    );
  }
}