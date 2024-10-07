import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // ใช้สำหรับการจัดการวันที่

class ImageOcrHelper {
  final ImagePicker _picker = ImagePicker(); // เลือกรูปภาพจากแกลเลอรี

  // ฟังก์ชันเลือกรูปภาพและแปลงข้อความจากรูป
  Future<Map<String, String?>> pickImageAndExtractText() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await extractTextFromImage(pickedFile.path);
    }
    return {'amount': null, 'datetime': null, 'memo': null};
  }

  // ฟังก์ชันแปลงภาพเป็นข้อความ
  Future<Map<String, String?>> extractTextFromImage(String path) async {
    String extractedText = await FlutterTesseractOcr.extractText(
      path,
      language: 'tha+eng', // ใช้ทั้งภาษาไทยและอังกฤษ
    );

    // ตรวจสอบว่าข้อความถูกดึงมาได้หรือไม่
    if (extractedText.isEmpty) {
      print("No text found.");
      return {'amount': null, 'datetime': null, 'memo': null};
    }

    // แสดงผลข้อความที่ดึงมาได้
    print("Extracted Text: $extractedText");

    // ตรวจจับและแยกเฉพาะตัวเลขที่เป็นทศนิยม
    final RegExp decimalPattern = RegExp(r'(?<!\S)(\d{1,3}(?:,\d{3})*)?\.\d{2}(?!\S)');
    final Iterable<Match> matches = decimalPattern.allMatches(extractedText);

    double totalAmount = matches.isNotEmpty
        ? matches.map((match) {
            String numberString = match.group(0)!.replaceAll(',', ''); // ลบลูกน้ำออก
            print("Matched Decimal: $numberString");  // ดูว่าเลขทศนิยมใดถูกจับได้
            return double.parse(numberString);
          }).reduce((a, b) => a + b)
        : 0.0;

    // ตรวจจับและแปลงวันที่และเวลา
    final RegExp dateTimePattern = RegExp(
      r'(\d{1,2})\s(.?[มกพสตพธn].?)\s*.{0,5}\s*([คพย])\s*.\s*(\d{2,4}).?\s*.?\s*(\d{1,3}:\d{2}(:\d{2})?)'
    );
    final Match? dateTimeMatch = dateTimePattern.firstMatch(extractedText);
    print("DMAte : $dateTimeMatch");
    String? formattedDateTime;

    if (dateTimeMatch != null) {
      String day = dateTimeMatch.group(1)!.padLeft(2, '0');
      String monthText = '${dateTimeMatch.group(2)}${dateTimeMatch.group(3)}';
      String year = dateTimeMatch.group(4)!;
      String time = dateTimeMatch.group(5)!;
      print('day : $day');
      print('monthText : $monthText');
      print('year : $year');
      print('time : $time');
      // แปลงชื่อเดือนให้เป็นเลขเดือน
      Map<String, String> monthMap = {
        'ม ค': '01', 
        'ก พ': '02', 'กุ พ': '02', 'n พ': '02',
        'มี ค': '03',
        'เม ย': '04',
        'พ ค': '05',
        'มิ ย': '06',
        'ก ค': '07', 'n ค': '07',
        'ส ค': '08',
        'ก ย': '09',
        'ต ค': '10',
        'พ ย': '11',
        'ธ ค': '12',
      };
      String month = monthMap[monthText]!;

      // ตรวจสอบปี หากเป็นปีแบบสองหลัก (เช่น 66) ให้แปลงเป็น 2567 (ในรูปแบบพุทธศักราช)
      if (year.length == 2) {
        year = '25' + year;  // ถ้าเป็นปีที่น้อยกว่าให้ถือว่าเป็นพุทธศักราช
      }

      // แปลงปีพุทธศักราชเป็นคริสต์ศักราชถ้าจำเป็น
      int extractedYear = int.parse(year);
      int currentYear = DateTime.now().year;
      if (extractedYear > currentYear) {
        extractedYear -= 543;
        print("Converted Year: $extractedYear");
      }
      year = extractedYear.toString();

       // สร้างรูปแบบวันที่และเวลา
      String hour = time.split(':')[0].padLeft(2, '0');
      String minute = time.split(':')[1];
      String second = time.split(':').length > 2 ? time.split(':')[2] : '00'; // ถ้าไม่มีวินาทีให้เป็น '00'
      String dateTimeString = '$year-$month-$day $hour:$minute:$second';

      // แปลงเป็น DateTime
      try {
        DateTime dateTime = DateTime.parse(dateTimeString);
        formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
      } catch (e) {
        print("Error parsing date: $e");
        formattedDateTime = null;  
      }
    }
    // } else {
    //   print("No date found.");
    //   formattedDateTime = null;
    // }

    final RegExp memoPattern = RegExp(
      r'(บ.{0,3}น.{0,3}ท.{0,3}ก.{1,12}า)\s*:\s*(.{1,150})'
    );
    final Match? memoMatch = memoPattern.firstMatch(extractedText);
    String? formattedMemo;

    if (memoMatch != null) {
      String keyword = memoMatch.group(1) ?? '';
      String memoContent = memoMatch.group(2) ?? '';

      // ลบช่องว่างระหว่างตัวอักษรในช่วง ก-ฮ
      formattedMemo = memoContent.replaceAll(RegExp(r'(?<=[ก-๙])\s+(?=[ก-๙])'), '');

      print("Keyword: $keyword");
      print("Memo Content: $formattedMemo");
    }
    // } else {
    //   print("No match found");
    // }
    
    // ส่งค่ากลับทั้งยอดรวมและวันที่/เวลา
    return {
      'amount': totalAmount > 0 ? totalAmount.toStringAsFixed(2) : null,
      'datetime': formattedDateTime,
      'memo' : formattedMemo
    };
  }
}