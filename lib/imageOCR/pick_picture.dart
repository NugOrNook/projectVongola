import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImageOcrHelper {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  // ฟังก์ชันสำหรับเลือกภาพจากแกลเลอรีและดึงข้อความ
  Future<String?> pickImageAndExtractText() async { //ฟังก์ชั่นจิ้มรูป
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await extractTextFromImage(pickedFile.path);
    }
    return null;
  }


  // ฟังก์ชันสำหรับดึงข้อความจากภาพที่แชร์หรือถูกเลือก
  Future<String?> extractTextFromImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String extractedText = '';
    
    for (TextBlock block in recognizedText.blocks) {
      // วนลูปผ่าน TextLine แต่ละบรรทัดใน block
      for (TextLine line in block.lines) {
        // วนลูปผ่าน TextElement ซึ่งเป็นองค์ประกอบแต่ละคำในบรรทัด
        for (TextElement element in line.elements) {
          print(element.text);
          final RegExp decimalPattern = RegExp(r'(?<!\S)(\d{1,3}(?:,\d{3})*)?\.\d{2}(?!\S)');
          if (decimalPattern.hasMatch(element.text)) {
            print("Matched Decimal: ${element.text}");  // ดูว่าเลขทศนิยมใดถูกจับได้
            extractedText += element.text + '\n ';
          }
        }
      }
    }

    await _textRecognizer.close(); // ปิดการทำงานของ OCR หลังจากเสร็จสิ้นการประมวลผล

    // ใช้ RegExp เพื่อค้นหาและกรองเฉพาะตัวเลขทศนิยม
    final RegExp decimalPattern = RegExp(r'\b\d{1,3}(?:,\d{3})*(?:\.\d{2})\b');
    final Iterable<Match> matches = decimalPattern.allMatches(extractedText);

    // รวมค่าทศนิยมทั้งหมดเข้าด้วยกัน
    double totalAmount = matches.isNotEmpty
        ? matches.map((match) {
            String numberString = match.group(0)!.replaceAll(',', ''); // ลบลูกน้ำออก
            return double.parse(numberString);
          }).reduce((a, b) => a + b)
        : 0.0;

    // คืนค่าเป็น Map ที่เก็บจำนวนเงิน, memo และ datetime
    return totalAmount.toStringAsFixed(2);
  }
}
