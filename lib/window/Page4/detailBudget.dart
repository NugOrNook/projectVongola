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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  late Future<List<Map<String, dynamic>>> _filteredBudgets;

  String _typeTransactionName = '';
  int? _idBudget; // ตัวแปรเพื่อเก็บ ID_budget
  bool _isEditing = false; // ควบคุมสถานะการแก้ไข

  @override
  void initState() {
    super.initState();
    _filteredBudgets = _loadFilteredBudgets();
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

    DateTime now = DateTime.now();
    return budgets.where((budget) {
      DateTime dateEnd = DateTime.parse(budget['date_end']);
      return budget['ID_type_transaction'] == idTypeTransaction && dateEnd.isAfter(now);
    }).toList();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Budget' : 'Budget Detail'),
          centerTitle: true, // จัด title ให้อยู่ตรงกลาง
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_isEditing) {
                setState(() {
                  _isEditing = false; // กลับไปหน้า Budget Detail
                });
              } else {
                Navigator.pop(context); // ถ้าไม่ได้อยู่ในโหมดแก้ไข ก็ย้อนกลับไปหน้าก่อนหน้า
              }
            },
          ),
        elevation: 1.0, // เพิ่มเงาใต้ AppBar
        bottom: PreferredSize( // เพิ่มเส้นแบ่งที่ด้านล่างของ AppBar
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: const Color.fromARGB(255, 217, 217, 217), // สีเส้นแบ่ง
            height: 1.0,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 20),
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
            boxShadow: [
                  BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _typeTransactionName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // กำหนดขนาดให้ ListView เพื่อไม่ให้ขยับ
              SizedBox(
                height: 300, // ระบุขนาดคงที่ให้กับ ListView
                child: _isEditing ? _buildEditForm(_idBudget!) : _buildBudgetList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // แสดงข้อมูลรายการ budget
  Widget _buildBudgetList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _filteredBudgets,
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
              String StartDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(budget['date_start']));
              String EndDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(budget['date_end']));

              return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
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
                    SizedBox(height: 50), // เพิ่มระยะห่างระหว่างรายการ

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _idBudget = budget['ID_budget'];
                                _amountController.text = budget['capital_budget'].toString();
                                _startDateController.text = StartDate;
                                _endDateController.text = EndDate;
                                _isEditing = !_isEditing;
                              });
                            },
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10), // Same padding as Save button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Match Save button's rounded corners
                              ),
                              backgroundColor: Color.fromARGB(255, 243, 240, 251), // Same background color as Save button
                              elevation: 1, // Increase elevation to match the Save button's shadow
                              shadowColor: Colors.black.withOpacity(1.0), // Subtle shadow for the bottom
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  // ฟอร์มแก้ไขข้อมูล budget
  Widget _buildEditForm(int _idBudget) {
    final int idBudget = _idBudget;

    return Container(
      padding: EdgeInsets.all(10),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'amountController',
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Capital Budget'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount of money';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            FormBuilderDateTimePicker(
              name: 'startDate',
              initialValue: DateFormat('yyyy-MM-dd').parse(_startDateController.text), // ใช้ค่า initialValue แทน controller
              decoration: InputDecoration(labelText: 'Start Date'),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              inputType: InputType.date,
              locale: Locale('th'),
            ),
            FormBuilderDateTimePicker(
              name: 'endDate',
              initialValue: DateFormat('yyyy-MM-dd').parse(_endDateController.text), // ใช้ค่า initialValue แทน controller
              decoration: InputDecoration(labelText: 'End Date'),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              inputType: InputType.date,
              locale: Locale('th'),
            ),  
            SizedBox(height: 50),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        var startDate = _formKey.currentState?.value['startDate'];
                        var endDate = _formKey.currentState?.value['endDate'];
                        var capitalBudget = _amountController.text;

                        // ตั้งค่าเวลาให้เป็นเที่ยงคืน
                        DateTime startDateTime = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
                        DateTime endDateTime = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

                        // ข้อมูลที่ต้องการบันทึก (บันทึกในรูปแบบ yyyy-MM-dd HH:mm:ss.SSS)
                        Map<String, dynamic> row = {
                          'date_start': startDateTime.toIso8601String(),  // แปลงเป็นรูปแบบ ISO 8601
                          'date_end': endDateTime.toIso8601String(),
                          'capital_budget': double.parse(capitalBudget),
                        };

                        // อัปเดตข้อมูลในฐานข้อมูล
                        await DatabaseManagement.instance.updateBudget(row, idBudget);

                        // กลับไปหน้าก่อนหน้า
                        Navigator.pop(context, true); // ส่งค่ากลับว่าเสร็จเรียบร้อย
                        // กลับไปหน้าก่อนหน้า
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailBudget(valued: widget.valued),
                        //   ),
                        // );
                      }
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
