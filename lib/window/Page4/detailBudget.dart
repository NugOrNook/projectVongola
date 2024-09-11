import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../database/db_manage.dart';
import 'package:flutter/services.dart';

class DetailBudget extends StatefulWidget {
  final String valued;

  DetailBudget({required this.valued});

  @override
  _DetailBudget createState() => _DetailBudget();
}

class _DetailBudget extends State<DetailBudget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30)); // ค่าเริ่มต้นของ End Date

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense & Income Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ปิดหน้า AddTransaction และย้อนกลับไปที่หน้าเดิม
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Value: ${widget.valued}', // ใช้ widget.valued เพื่อเข้าถึงค่าที่ส่งมาจาก Budgetcatagory
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
