import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../database/db_manage.dart';
import 'package:intl/intl.dart'; // ใช้สำหรับจัดการวันที่

class DetailBudget extends StatefulWidget {
  final String valued;

  DetailBudget({required this.valued});

  @override
  _DetailBudget createState() => _DetailBudget();
}

class _DetailBudget extends State<DetailBudget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _filteredBudgets; // สร้างตัวแปรใหม่สำหรับ filtered budgets
  late Future<Map<int, String>> _typeTransactions;

  String _typeTransactionName = '';

  @override
  void initState() {
    super.initState();
    _typeTransactions = DatabaseManagement.instance.getTypeTransactionsMap();
    _filteredBudgets = _loadFilteredBudgets(); // โหลดข้อมูล budgets ที่กรองแล้ว
    _loadTypeTransactionName();
  }

  Future<void> _loadTypeTransactionName() async {
    int id = int.parse(widget.valued);
    String? name = await DatabaseManagement.instance.getTypeTransactionNameById(id);
    setState(() {
      _typeTransactionName = name ?? 'Unknown';
    });
  }

  Future<List<Map<String, dynamic>>> _loadFilteredBudgets() async {
    int idTypeTransaction = int.parse(widget.valued);
    List<Map<String, dynamic>> budgets = await DatabaseManagement.instance.queryAllBudgets();
    
    // กรองข้อมูลให้ตรงกับ ID_type_transaction และ DateEnd ไม่เกินเวลาปัจจุบัน
    DateTime now = DateTime.now();
    return budgets.where((budget) {
      DateTime dateEnd = DateTime.parse(budget['date_end']);
      return budget['ID_type_transaction'] == idTypeTransaction && dateEnd.isAfter(now);
    }).toList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Budget'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding( // เพิ่ม Padding รอบนอกของ Container
        padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
        child: Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _typeTransactionName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: _buildBudgetList(), // ListView จะขยายพื้นที่ได้ตามที่ต้องการ
                
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('...',
                      textAlign: TextAlign.center, // จัดตำแหน่งข้อความให้ตรงกลาง
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  )
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget _buildBudgetList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _filteredBudgets, // ใช้ budgets ที่กรองแล้ว
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No budgets found.'));
        } else {
          final budgets = snapshot.data!;
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              String formattedStartDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(budget['date_start']));
              String formattedEndDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(budget['date_end']));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Capital', style: TextStyle(fontSize: 16)),
                      Text('${budget['capital_budget']} ฿', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start date', style: TextStyle(fontSize: 16)),
                      Text('$formattedStartDate', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('End date', style: TextStyle(fontSize: 16)),
                      Text('$formattedEndDate', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 8), // เพิ่มระยะห่างระหว่างรายการ
                ],
              );
            },
          );
        }
      },
    );
  }
}
