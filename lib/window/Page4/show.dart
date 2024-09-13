import 'package:flutter/material.dart';
import '../../database/db_manage.dart';

class BudgetList extends StatefulWidget {
  @override
  _BudgetListState createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  late Future<List<Map<String, dynamic>>> _budgets;
  late Future<Map<int, String>> _typeTransactions;

  @override
  void initState() {
    super.initState();
    _budgets = DatabaseManagement.instance.queryAllBudgets();
    _typeTransactions = DatabaseManagement.instance.getTypeTransactionsMap();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _budgets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No budgets found.'));
        } else {
          final budgets = snapshot.data!;
          return FutureBuilder<Map<int, String>>(
            future: _typeTransactions,
            builder: (context, typeSnapshot) {
              if (typeSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (typeSnapshot.hasError) {
                return Center(child: Text('Error: ${typeSnapshot.error}'));
              } else if (!typeSnapshot.hasData || typeSnapshot.data!.isEmpty) {
                return Center(child: Text('No type transactions found.'));
              } else {
                final typeTransactions = typeSnapshot.data!;
                return ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    final typeTransaction = typeTransactions[budget['ID_type_transaction']] ?? 'Unknown';

                    return ListTile(
                      title: Text('Budget ID: ${budget['ID_budget']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: $typeTransaction'),
                          Text('Capital: ${budget['capital_budget']}'),
                          Text('Start: ${budget['date_start']} - End: ${budget['date_end']}'),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
