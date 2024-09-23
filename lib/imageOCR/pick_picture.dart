import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImageOcrHelper {
  final ImagePicker _picker = ImagePicker(); //class ImagePicker มีอยู่แล้ว ใช้เพื่อเอาไว้เลือกรูป _picker เป็นตัวแปรที่เก็บอินสแตนซ์ของ ImagePicker ไว้ และใช้เพื่อเข้าถึงเมธอดต่างๆ ของ ImagePicker เช่น การเลือกภาพจากแกลเลอรีหรือถ่ายภาพด้วยกล้อง
  final TextRecognizer _textRecognizer = TextRecognizer();//class TextRecognizer มีอยู่แล้วเหมือนกัน

  Future<String?> pickImageAndExtractText() async { //ฟังก์ชั่นจิ้มรูป
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await extractTextFromImage(pickedFile.path);
    }
    return null;
  }

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

    await _textRecognizer.close();  // ปิด TextRecognizer

    final RegExp decimalPattern = RegExp(r'(จำนวนเงิน)?\s*(\d{1,3}(?:,\d{3})*\.\d{2})\s*');
    final Iterable<Match> matches = decimalPattern.allMatches(extractedText);

    double totalAmount = matches.isNotEmpty
        ? matches.map((match) {
      String numberString = match.group(0)!.replaceAll(',', ''); // ลบลูกน้ำออก
      return double.parse(numberString);
    }).reduce((a, b) => a + b)
        : 0.0;

    return totalAmount.toStringAsFixed(2);
  }
}