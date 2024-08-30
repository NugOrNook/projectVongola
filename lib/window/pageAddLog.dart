import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../database/db_manage.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

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
                name: 'date',
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    var typeExpense =
                        _formKey.currentState?.value['transactionType'];
                    var date = _formKey.currentState?.value['date'];
                    var category = _formKey.currentState?.value['category'];
                    var amount = _amountController.text;
                    var memo = _memoController.text;

                    // Get category ID
                    int? typeTransactionId =
                        await DatabaseManagement.instance.getTypeTransactionId(
                      category,
                    );

                    if (typeTransactionId == null) {
                      // Handle the case where category ID is not found
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid category selected.'),
                        ),
                      );
                      return;
                    }

                    Map<String, dynamic> row = {
                      'date_user': date.toString(),
                      'amount_transaction': double.parse(amount),
                      'type_expense': typeExpense == '1' ? 1 : 0,
                      'memo_transaction': memo,
                      'ID_type_transaction': typeTransactionId,
                    };

                    // Insert transaction into the database
                    await DatabaseManagement.instance.insertTransaction(row);

                    // กลับไปที่หน้าก่อนหน้าและส่งค่า
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





// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import '../database/db_manage.dart';

// class AddTransaction extends StatefulWidget {
//   @override
//   _AddTransactionState createState() => _AddTransactionState();
// }

// class _AddTransactionState extends State<AddTransaction> {
//   final _formKey = GlobalKey<FormBuilderState>();
//   final _AmountMoney = GlobalKey<FormBuilderState>();
//   final _Memo = GlobalKey<FormBuilderState>();
  
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Expense & Income Log'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // ปิดหน้า AddTransaction และย้อนกลับไปที่หน้าเดิม
//           },
//         ),
//       ),
//       // body: Center(
//       //   /*child: Text('This is the Add Transaction page'),*/
//       // ),
//       body: Container(
//         padding: EdgeInsets.all(10),
//         child: FormBuilder(
//           key: _formKey,
//           child: Column(
//             children: [

//               FormBuilderChoiceChip<String>(
//                 name: 'transactionType',
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                 ),
//                 spacing: 16.0, // กำหนดระยะห่างระหว่างปุ่ม
//                 alignment: WrapAlignment.center, // จัดตำแหน่งปุ่มให้อยู่ตรงกลาง
//                 options: [
//                   FormBuilderChipOption<String>(
//                     value: "0",
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // กำหนด padding ของปุ่ม
//                         child: Text("Income"),
//                       ),
//                     ),
//                   ),
//                   FormBuilderChipOption<String>(
//                     value: "1",
//                     child: Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // กำหนด padding ของปุ่ม
//                         child: Text("Expense"),
//                       ),
//                     ),
//                   ),
//                 ],
//                 validator: FormBuilderValidators.required(
//                   errorText: 'Please select a transaction type',
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 name: 'date',
//                 initialValue: DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//                 inputType: InputType.both,
//                 decoration: InputDecoration(
//                   labelText: 'Appointment Date',
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 initialTime: TimeOfDay(hour: 8, minute: 0),
//                 locale: Locale('th'),
//               ),

//               FormBuilderDropdown<String>(
//                 name: 'category',
//                 decoration: InputDecoration(
//                   labelText: 'Select Category',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   DropdownMenuItem(value: 'Null', child: Text('Please Select'),),
//                   DropdownMenuItem(value: 'Food', child: Text('Food'),),
//                   DropdownMenuItem(value: 'Travel expenses', child: Text('Travel expenses'),),
//                   DropdownMenuItem(value: 'Water bill', child: Text('Water bill'),),
//                   DropdownMenuItem(value: 'Electricity bill', child: Text('Electricity bill'),),
//                   DropdownMenuItem(value: 'House cost', child: Text('House cost'),),
//                   DropdownMenuItem(value: 'Car fare', child: Text('Car fare'),),
//                   DropdownMenuItem(value: 'Gasoline cost', child: Text('Gasoline cost'),),
//                   DropdownMenuItem(value: 'Cost of equipment', child: Text('Cost of equipment'),),
//                   DropdownMenuItem(value: 'Other', child: Text('Other'),),
//                 ],
//                 validator: FormBuilderValidators.required(
//                   errorText: 'Please select a category',
//                 ),
//               ),

//               FormBuilderTextField( 
//                 key: _AmountMoney,
//                 name: 'AmountMoney',
//                 decoration: const InputDecoration(labelText: 'Amount Money'),
//                 validator: FormBuilderValidators.required(
//                   errorText: 'Please select a category',
//                 ),
//               ),
//               const SizedBox(height: 10),

//               FormBuilderTextField( 
//                 key: _Memo,
//                 name: 'Memo',
//                 decoration: const InputDecoration(labelText: 'Memo'),
//               ),
//               const SizedBox(height: 10),

//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.saveAndValidate()) {
//                       final formData = _formKey.currentState!.value;

//                       // ดึงข้อมูลจากฟอร์ม
//                       String transactionType = formData['transactionType'];
//                       DateTime date = formData['date'];
//                       String category = formData['category'];
//                       double amount = double.parse(formData['AmountMoney']);
//                       String memo = formData['Memo'] ?? '';

//                       // สร้าง Map สำหรับบันทึกข้อมูลลง database
//                       Map<String, dynamic> newTransaction = {
//                         'date_user': date.toIso8601String(),
//                         'amount_transaction': amount,
//                         'type_expense': transactionType == '1',  // ใช้ boolean สำหรับ 'Expense' (1 = true)
//                         'memo_transaction': memo,
//                         'ID_type_transaction': null,  // ใส่ ID_type_transaction ที่ต้องการ ถ้ามี
//                       };

//                     // เรียกใช้ฟังก์ชัน insertTransaction จาก DatabaseManagement
//                     DatabaseManagement.instance.insertTransaction(newTransaction);

//                     // แสดงข้อความแจ้งผู้ใช้
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Transaction saved successfully')),
//                     );

//                     // หลังจากบันทึกข้อมูลสามารถสั่งย้อนกลับ หรือ รีเซ็ตฟอร์ม
//                     Navigator.pop(context); // ย้อนกลับไปหน้าก่อนหน้า
//                   }
//                 },
//                 child: Text('Submit'),
//               ),
//             ),


//               // Padding(
//               //   padding: const EdgeInsets.symmetric(vertical: 16.0),
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       if (_formKey.currentState!.saveAndValidate()) {
//               //         final selectedDate = _formKey.currentState!.value['date'];
//               //         ScaffoldMessenger.of(context).showSnackBar(
//               //           SnackBar(content: Text('Selected Date: $selectedDate')),
//               //         );
//               //       }
//               //     },
//               //     child: Text('Submit'),
//               //   ),
//               // ),


//               // FormBuilderTextField( 
//               //   key: _emailFieldKey,
//               //   name: 'email',
//               //   decoration: const InputDecoration(labelText: 'Email'),
//               // ),
//               // const SizedBox(height: 10),
              
//               // FormBuilderTextField(
//               //   name: 'password',
//               //   decoration: const InputDecoration(labelText: 'Password'),
//               //   obscureText: true,
//               // ),
      
//               // MaterialButton(
//               //   color: Theme.of(context).colorScheme.secondary,
//               //   onPressed: () {
//               //     // Validate and save the form values
//               //     _formKey.currentState?.saveAndValidate();
//               //     debugPrint(_formKey.currentState?.value.toString());

//               //     // On another side, can access all field values without saving form with instantValues
//               //     _formKey.currentState?.validate();
//               //     debugPrint(_formKey.currentState?.instantValue.toString());
//               //   },
//               //   child: const Text('Login'),
//               // )
//             ]
//           ),
//         ),
//       )
      
//     );
//   }
// }
