import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../imageOCR/pick_picture.dart';
import '../../../database/db_manage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final ImageOcrHelper _imageOcrHelper = ImageOcrHelper();
  
  String? _transactionType = '1'; // เก็บค่าของประเภทการทำธุรกรรม

  @override
  void dispose() {
    _amountController.dispose();
    _dateTimeController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndExtractText() async {
    final extractedData = await _imageOcrHelper.pickImageAndExtractText();
    if (extractedData != null) {
      setState(() {
        // ตั้งค่า amount และ datetime จาก extractedData
        _amountController.text = extractedData['amount'] ?? '';
        _dateTimeController.text = extractedData['datetime'] ?? '';
        _memoController.text = extractedData['memo'] ?? '';
        _formKey.currentState?.fields['transactionType']?.didChange('1');
        _transactionType = '1';
      });
    }
  }

  Future<void> _handleIncomingImage(String imageUri) async {
    final extractedData = await _imageOcrHelper.extractTextFromImage(imageUri);
    if (extractedData != null) {
      setState(() {
        // ตั้งค่า amount และ datetime จาก extractedData
        _amountController.text = extractedData['amount'] ?? '';
        _dateTimeController.text = extractedData['datetime'] ?? '';
        _memoController.text = extractedData['memo'] ?? '';
        _formKey.currentState?.fields['transactionType']?.didChange('1');
        _transactionType = '1';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final String? _sharingFile = ModalRoute.of(context)!.settings.arguments as String?;
    if (_sharingFile != null) {
      _handleIncomingImage(_sharingFile);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Expense & Income Log'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderField<String>(
                  name: 'transactionType',
                  builder: (FormFieldState<String?> field) {
                    return Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: ChoiceChip(
                                label: Text("Income", style: TextStyle(fontSize: 16)),
                                selected: field.value == "0",
                                selectedColor: Colors.transparent,
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (selected) {
                                  field.didChange(selected ? "0" : null);
                                  setState(() {
                                    _transactionType = "0"; // กำหนดให้เป็น "Income"
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 25),
                            Flexible(
                              child: ChoiceChip(
                                label: Text("Expense", style: TextStyle(fontSize: 16)),
                                selected: field.value == "1",
                                selectedColor: Colors.transparent,
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (selected) {
                                  field.didChange(selected ? "1" : null);
                                  setState(() {
                                    _transactionType = "1"; // กำหนดให้เป็น "Expense"
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  validator: FormBuilderValidators.required(
                    errorText: 'Please select a transaction type'
                  ),
                ),
                SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Date',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(0, -8),  // เลื่อนขึ้นหรือลงตามที่ต้องการ
                      child:FormBuilderDateTimePicker(
                        name: 'dateTimeController',
                        controller: _dateTimeController,
                        initialValue: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        inputType: InputType.both,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          isDense: true, 
                          contentPadding: EdgeInsets.only(bottom: 10), // ลดระยะห่างระหว่างข้อความและเส้น
                          suffixIcon: Icon(Icons.calendar_today),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 20,  // ปรับขนาดความสูงของไอคอน
                            minWidth: 20,
                            maxHeight: 20,  // ป้องกันไม่ให้ไอคอนเพิ่มความสูงของ widget
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14, // ขนาดฟอนต์เล็กลงเพื่อให้พอดีกับพื้นที่
                          height: 1.0, // ลดความสูงของข้อความ
                        ),
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                        locale: Locale('th'),
                      ),
                    ),
                  ],
                ),

                // ซ่อน Category dropdown เมื่อเป็น Income
                if (_transactionType == "1") // แสดงเมื่อเป็น "Expense"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(0, -8),
                        child: FormBuilderDropdown<String>(
                          name: 'category',
                          decoration: InputDecoration(
                            hintText: 'Please select a category',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                              fontWeight: FontWeight.w300,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: UnderlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem(value: 'Food', child: Text('Food')),
                            DropdownMenuItem(value: 'Travel expenses', child: Text('Travel expenses')),
                            DropdownMenuItem(value: 'Water bill', child: Text('Water bill')),
                            DropdownMenuItem(value: 'Electricity bill', child: Text('Electricity bill')),
                            DropdownMenuItem(value: 'House cost', child: Text('House cost')),
                            DropdownMenuItem(value: 'Car fare', child: Text('Car fare')),
                            DropdownMenuItem(value: 'Gasoline cost', child: Text('Gasoline cost')),
                            DropdownMenuItem(value: 'Medical expenses', child: Text('Medical expenses')),
                            DropdownMenuItem(value: 'Beauty expenses', child: Text('Beauty expenses')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          // ปรับ validator ให้ตรวจสอบเฉพาะเมื่อเป็น Expense
                          validator: (value) {
                            if (_transactionType == "1" && (value == null || value == "Null")) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(0, -8),
                        child: FormBuilderTextField(
                          name: 'amountController',
                          controller: _amountController,
                          decoration: InputDecoration(
                            hintText: 'Please enter the amount of money',
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                              fontWeight: FontWeight.w300,
                            ),
                            border: UnderlineInputBorder(),
                            isDense: true,
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
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Memo', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'memoController',
                    controller: _memoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _pickImageAndExtractText,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.photo),
                        SizedBox(width: 10),
                        Text('Pick Image'),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.saveAndValidate()) {
                          var typeExpense = _formKey.currentState?.value['transactionType'];
                          var date = _dateTimeController.text;
                          var category = typeExpense == '0' ? "IC" : _formKey.currentState?.value['category']; // กำหนดค่าเป็น "None" ถ้าเป็น Income
                          var amount = _amountController.text;
                          var memo = _memoController.text;

                          // Get category ID
                          int? typeTransactionId = await DatabaseManagement.instance.getTypeTransactionId(category);

                          if (typeTransactionId == null) {
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
                      child: Text('Save'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



