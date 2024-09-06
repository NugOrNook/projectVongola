import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../imageOCR/pick_picture.dart';
import '../database/db_manage.dart';
import 'package:flutter/services.dart';

class AddTransaction extends StatefulWidget {
  //------------< พอยเพิ่ม >------------------
  final String? imageUri; 
  AddTransaction({Key? key, this.imageUri}) : super(key: key);
  //-----------------------------------------

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final ImageOcrHelper _imageOcrHelper = ImageOcrHelper();  // สร้างอินสแตนซ์ของ ImageOcrHelper พอย

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  //---------------------------------------< พอยเพิ่ม >---------------------------------------------------
  Future<void> _pickImageAndExtractText() async { //พอย
    final extractedText = await _imageOcrHelper.pickImageAndExtractText(); //ผลลัพธ์ที่ได้จะถูกเก็บในตัวแปร extractedText อยู่ในไฟล์ pick_picture.dart
    if (extractedText != null) { //ตรวจสอบว่า OCR สามารถดึงข้อความออกมาได้มั้ย
      setState(() {
        _amountController.text = extractedText; // ตั้งค่าจำนวนเงิน
        _formKey.currentState?.fields['transactionType']?.didChange('1'); // '1' คือค่า "Expense"
      });
    }
  }

  Future<void> _handleIncomingImage(String imageUri) async { //พอย
    final extractedText = await _imageOcrHelper.extractTextFromImage(imageUri);
    if (extractedText != null) {
      setState(() {
        _amountController.text = extractedText; // ตั้งค่าจำนวนเงิน
      });
    }
  }

  @override //พอย
  void initState() {
    super.initState();

    // ตรวจสอบว่ามีค่า imageUri มั้ย
    if (widget.imageUri != null && widget.imageUri!.isNotEmpty) {
      _handleIncomingImage(widget.imageUri!); // เรียกใช้ฟังก์ชันที่จัดการกับภาพที่แชร์
    }

    // เพิ่มการตั้งค่าที่นี่เพื่อรับข้อมูลจากการแชร์
    const MethodChannel channel = MethodChannel("vongola");
    channel.setMethodCallHandler((call) async {
      if (call.method == 'shareImage') {
        final String imageUri = call.arguments; // รับค่า imageUri จากการแชร์
        await _handleIncomingImage(imageUri); // เรียกฟังก์ชันเพื่อจัดการกับภาพที่แชร์
      }
    });
  }
  //-------------------------------------------------------------------------------------

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderChoiceChip<String>(
                name: 'transactionType',
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                spacing: 16.0, // กำหนดระยะห่างระหว่างปุ่ม
                alignment: WrapAlignment.center, // จัดตำแหน่งปุ่มให้อยู่ตรงกลาง
                options: [
                  FormBuilderChipOption<String>(
                    value: "0",
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20), // กำหนด padding ของปุ่ม
                        child: Text("Income"),
                      ),
                    ),
                  ),
                  FormBuilderChipOption<String>(
                    value: "1",
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20), // กำหนด padding ของปุ่ม
                        child: Text("Expense"),
                      ),
                    ),
                  ),
                ],
                validator: FormBuilderValidators.required(
                  errorText: 'Please select a transaction type',
                ),
              ),
              FormBuilderDateTimePicker(
                name: 'dateTimeController',
                controller: _dateTimeController,
                initialValue: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                inputType: InputType.both,
                decoration: InputDecoration(
                  labelText: 'Appointment Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                initialTime: TimeOfDay(hour: 8, minute: 0),
                locale: Locale('th'),
              ),
              FormBuilderDropdown<String>(
                name: 'category',
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'Null', child: Text('Please Select'),),
                  DropdownMenuItem(value: 'Food', child: Text('Food'),),
                  DropdownMenuItem(value: 'Travel expenses', child: Text('Travel expenses'),),
                  DropdownMenuItem(value: 'Water bill', child: Text('Water bill'),),
                  DropdownMenuItem(value: 'Electricity bill', child: Text('Electricity bill'),),
                  DropdownMenuItem(value: 'House cost', child: Text('House cost'),),
                  DropdownMenuItem(value: 'Car fare', child: Text('Car fare'),),
                  DropdownMenuItem(value: 'Gasoline cost', child: Text('Gasoline cost'),),
                  DropdownMenuItem(value: 'Cost of equipment', child: Text('Cost of equipment'),),
                  DropdownMenuItem(value: 'Other', child: Text('Other'),),
                ],
                validator: FormBuilderValidators.required(
                  errorText: 'Please select a category',
                ),
              ),

              FormBuilderTextField(
                name: 'amountController',
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount of Money',
                  border: OutlineInputBorder(),
                ),
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

              FormBuilderTextField(
                name: 'memoController',
                controller: _memoController,
                decoration: InputDecoration(
                  labelText: 'Memo',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              // ปุ่มสำหรับการเลือกภาพ
              ElevatedButton(
                onPressed: _pickImageAndExtractText, // ฟังก์ชันเลือกและดึงข้อมูลจากภาพ
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 8),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    var typeExpense = _formKey.currentState?.value['transactionType'];
                    var date = _formKey.currentState?.value['date'];
                    var category = _formKey.currentState?.value['category'];
                    var amount = _amountController.text;
                    var memo = _memoController.text;

                    // Get category ID
                    int? typeTransactionId = await DatabaseManagement.instance.getTypeTransactionId(category);

                    if (typeTransactionId == null) {
                      // แสดงข้อความเมื่อไม่พบ category ID
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid category selected.'),
                        ),
                      );
                      return;
                    }

                    // ข้อมูลที่ต้องการบันทึก
                    Map<String, dynamic> row = {
                      'date_user': date.toString(),
                      'amount_transaction': double.parse(amount),
                      'type_expense': typeExpense == '1' ? 1 : 0,
                      'memo_transaction': memo,
                      'ID_type_transaction': typeTransactionId,
                    };

                    // บันทึกข้อมูลลงฐานข้อมูล
                    await DatabaseManagement.instance.insertTransaction(row);

                    // กลับไปหน้าก่อนหน้าและส่งค่า
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}