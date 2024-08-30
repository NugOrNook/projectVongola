import 'package:flutter/material.dart';

class CardDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromARGB(255, 42, 184, 250), // กำหนดสีของ Card
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30), // สีเมื่อกด
          onTap: () {
            // ฟังก์ชันที่เรียกเมื่อมีการกด
            debugPrint('Card tapped.'); // แสดงข้อความใน console เมื่อกด
          },
          child: SizedBox(
            width: 320, // ความกว้างของ Card
            height: 120, // ความสูงของ Card
            child: Center(
              // จัดข้อความให้อยู่ตรงกลาง
              child: Text(
                'A card that can be tapped',
                style: TextStyle(
                  color: Colors.white, // กำหนดสีของข้อความ
                  fontSize: 18, // ขนาดของข้อความ
                  fontWeight: FontWeight.bold, // ทำให้ข้อความหนา
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
