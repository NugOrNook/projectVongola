import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import '../../../imageOCR/pick_picture.dart';
import '../../../database/db_manage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final TextEditingController _referralController = TextEditingController();
  final ImageOcrHelper _imageOcrHelper = ImageOcrHelper();
  int _memoLength = 0;
  bool isSharing = false;
  String? _transactionType = '1';

  @override
  void dispose() {
    isSharing = false;
    _amountController.dispose();
    _dateTimeController.dispose();
    _memoController.dispose();
    _referralController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _memoController.addListener(() {
      setState(() {
        _memoLength = _memoController.text.length;
      });
    });
  }

  Future<void> _pickImageAndExtractText() async {
    final extractedData = await _imageOcrHelper.pickImageAndExtractText();
    if (extractedData != null) {
    setState(() {
      // ตั้งค่า amount และ datetime จาก extractedData
      _amountController.text = extractedData['amount'] ?? '';
      _dateTimeController.text = extractedData['datetime'] ?? '';
      _memoController.text = extractedData['memo'] ?? '';
      _referralController.text = extractedData['referral'] ?? '';
      _formKey.currentState?.fields['transactionType']?.didChange('1');
      _transactionType = '1';
    });
    }
  }

  Future<void> _handleIncomingImage(String imageUri) async {
    final extractedData = await _imageOcrHelper.extractTextFromImage(imageUri);
    //if (extractedData != null) {
    setState(() {
      _amountController.text = extractedData['amount'] ?? '';
      _dateTimeController.text = extractedData['datetime'] ?? '';
      _memoController.text = extractedData['memo'] ?? '';
      _referralController.text = extractedData['referral'] ?? '';
      _formKey.currentState?.fields['transactionType']?.didChange('1');
      _transactionType = '1';
    });
    //}
  }


  @override
  Widget build(BuildContext context) {
    final String? _sharingFile = ModalRoute.of(context)!.settings.arguments as String?;
    if (_sharingFile != null&&!isSharing) {
      isSharing=true;
      _handleIncomingImage(_sharingFile);
    }
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(localizations.expenseIncomeLog),
        elevation: 5.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 9, 209, 220), Color(0xFEF7FFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
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
                  initialValue: _transactionType,
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
                                label: Text(localizations.income, style: TextStyle(fontSize: 16)),
                                selected: field.value == "0",
                                selectedColor: Colors.green[200],
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (selected) {
                                  if (field.value != "0") { // ป้องกันการยกเลิกการเลือก
                                    field.didChange("0");
                                    setState(() {
                                      _transactionType = "0";
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 25),
                            Flexible(
                              child: ChoiceChip(
                                label: Text(localizations.expense, style: TextStyle(fontSize: 16)),
                                selected: field.value == "1",
                                selectedColor: Colors.red[200],
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (selected) {
                                  if (field.value != "1") { // ป้องกันการยกเลิกการเลือก
                                    field.didChange("1");
                                    setState(() {
                                      _transactionType = "1";
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.pleaseselectatransactiontype;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: _pickImageAndExtractText,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(240, 40),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo, size: 20),
                      SizedBox(width: 5),
                      Text(
                        localizations.pickImage,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),


                SizedBox(height: 15),
                if (_transactionType == "1")
                  Column( //cat
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localizations.category, style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Transform.translate(
                        offset: Offset(0, -8),
                        child: FormBuilderDropdown<String>(
                          name: 'category',
                          decoration: InputDecoration(
                            hintText: localizations.pleaseselectacategory,
                            hintStyle: GoogleFonts.roboto(
                              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                              fontWeight: FontWeight.w300,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 10),
                            border: UnderlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem(value: 'Food', child: Text(localizations.food)),
                            DropdownMenuItem(value: 'Travel expenses', child: Text(localizations.travelexpenses)),
                            DropdownMenuItem(value: 'Water bill', child: Text(localizations.waterbill)),
                            DropdownMenuItem(value: 'Electricity bill', child: Text(localizations.electricitybill)),
                            DropdownMenuItem(value: 'Internet cost', child: Text(localizations.internetcost)),
                            DropdownMenuItem(value: 'House cost', child: Text(localizations.housecost)),
                            DropdownMenuItem(value: 'Car fare', child: Text(localizations.carfare)),
                            DropdownMenuItem(value: 'Gasoline cost', child: Text(localizations.gasolinecost)),
                            DropdownMenuItem(value: 'Medical expenses', child: Text(localizations.medicalexpenses)),
                            DropdownMenuItem(value: 'Beauty expenses', child: Text(localizations.beautyexpenses)),
                            DropdownMenuItem(value: 'Other', child: Text(localizations.other)),
                          ],
                          validator: (value) {
                            if (_transactionType == "1" && (value == null || value == "Null")) {
                              return localizations.pleaseselectacategory;
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
                    Text(
                      localizations.appointmentDate,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    Transform.translate(
                      offset: Offset(0, -8),
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
                          contentPadding: EdgeInsets.only(bottom: 10),
                          suffixIcon: Icon(Icons.calendar_today),
                          suffixIconConstraints: BoxConstraints(
                            minHeight: 20,
                            minWidth: 20,
                            maxHeight: 20,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.0,
                        ),
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                        locale: Locale('th'),
                      ),
                    ),
                  ],
                ),




                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.amount, style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: FormBuilderTextField(
                        name: 'amountController',
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: localizations.pleaseentertheamountofmoney,
                          hintStyle: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            fontWeight: FontWeight.w300,
                          ),
                          border: UnderlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.pleaseentertheamountofmoney;
                          }
                          String amountString = value.replaceAll(",", "");
                          if (double.tryParse(amountString) == null) {

                            print('***************************************');
                            return localizations.pleaseenteravalidnumber;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),//amount
                SizedBox(height: 10),

                Container(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(localizations.memo, style: TextStyle(fontSize: 14)),
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
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(35),
                  ],
                ),//memo
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_memoLength} / 35 ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),




                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        bool referralExists = await DatabaseManagement.instance.checkReferralExists(_referralController.text);
                        if (referralExists) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.thissliphasalreadybeenrecorded),
                            ),
                          );
                          return;
                        }


                        DateTime dateTimeValue = _dateTimeController.text.isNotEmpty
                            ? DateFormat('dd/MM/yyyy HH:mm:ss').parse(_dateTimeController.text)
                            : DateTime.now();


                        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeValue);

                        var typeExpense = _formKey.currentState?.value['transactionType'];
                        var date = formattedDate;
                        var category = typeExpense == '0' ? "IC" : _formKey.currentState?.value['category'];
                        var amount = _amountController.text;
                        var memo = _memoController.text;
                        var referral = _referralController.text;

                        int? typeTransactionId = await DatabaseManagement.instance.getTypeTransactionId(category);

                        if (typeTransactionId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.invalidcategoryselected),
                            ),
                          );
                          return;
                        }
                        String amountString = amount.replaceAll(",", "");

                        Map<String, dynamic> row = {
                          'date_user': date.toString(),
                          'amount_transaction': double.parse(amountString),
                          'type_expense': typeExpense == '1' ? 1 : 0,
                          'memo_transaction': memo,
                          'ID_type_transaction': typeTransactionId,
                          'referral_code': referral,
                        };
                        // ันทึกข้อมูลลงฐานข้อมูล
                        await DatabaseManagement.instance.insertTransaction(row);

                        //กลับไปหน้าก่อนหน้าและส่งค่า
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text(localizations.save),
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


