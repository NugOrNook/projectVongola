import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showDateDetailsDialog(
    BuildContext context,
    List<Map<String, dynamic>> expenses,
    DateTime date,
    Function(int, double, String) onEditExpense,
    Function(int) onDeleteExpense,
    ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return AlertDialog(
        title: Text(DateFormat('dd MMM yyyy').format(date.toLocal())),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
          child: SingleChildScrollView(
            child: Column(
              children: expenses.isEmpty
                  ? [Image.asset('assets/Zzz.png', width: 100, height: 100), Text('No records for this day')]
                  : expenses.map((expense) {
                return ListTile(
                  leading: Image.asset('assets/${expense['type']}.png', width: 50, height: 50),
                  title: Text(expense['incomeexpense'] == 0 ? 'Income' : expense['type']),
                  subtitle: Text('Amount: ${expense['amount']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showEditExpenseDialog(context, expense, onEditExpense);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          onDeleteExpense(expense['ID_transaction_Primary']);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
      );
    },
  );
}

void showEditExpenseDialog(BuildContext context, Map<String, dynamic> expense, Function(int, double, String) onSave) {
  TextEditingController amountController = TextEditingController(text: expense['amount'].toString());
  TextEditingController memoController = TextEditingController(text: expense['memo'].toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: amountController, decoration: InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
            TextField(controller: memoController, decoration: InputDecoration(labelText: 'Memo')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedAmount = double.tryParse(amountController.text) ?? 0.0;
              final updatedMemo = memoController.text;
              onSave(expense['ID_transaction_Primary'], updatedAmount, updatedMemo);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
