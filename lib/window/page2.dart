import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) => Text("h02");

} 
// import 'dart:async';
  
// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
  
// import '../database/book_db.dart';
// import '../model/book_model.dart';
    
// class Books extends StatefulWidget {
//     static const routeName = '/book';
   
//     const Books({Key? key}) : super(key: key);
    
//     @override
//     State<StatefulWidget> createState() {
//         return _BooksState();
//     }
// }
    
// class _BooksState extends State<Books> {
//     late BooksDatabase _db; // อ้างอิงฐานข้อมูล
//     late Future<List<Book>> books; // ลิสรายการหนังสือ
//     int i = 0; // จำลองตัวเลขการเพิ่่มจำนวน
//     late DateFormat dateFormat; // รูปแบบการจัดการวันที่และเวลา
  
//     @override
//     void initState() {
//       // กำหนดรูปแบบการจัดการวันที่และเวลา มีเพิ่มเติมเล็กน้อยในในท้ายบทความ
//       Intl.defaultLocale = 'th';
//       initializeDateFormatting();
//       dateFormat = DateFormat.yMMMMEEEEd('th');
  
//       // อ้างอิงฐานข้อมูล
//       _db = BooksDatabase.instance;
//       books = _db.readAllBook(); // แสดงรายการหนังสือ
//       super.initState();
//     }
  
//     // คำสั่งลบรายการทั้งหมด
//     Future<void> clearBook() async {
//       await _db.deleteAll(); // ทำคำสั่งลบข้อมูลทั้งหมด
//       setState(() {
//         books = _db.readAllBook(); // แสดงรายการหนังสือ
//       });      
//     }
  
//     // คำสั่งลบเฉพาะรายการที่กำหนดด้วย id ที่ต้องการ
//     Future<void> deleteBook(int id) async {
//       await _db.delete(id); // ทำคำสั่งลบข้มูลตามเงื่อนไข id
//       setState(() {
//         books = _db.readAllBook(); // แสดงรายการหนังสือ
//       });    
//     }
  
//     // จำลองทำคำสั่งแก้ไขรายการ
//     Future<void> editBook(Book book) async {
//       // เลื่อกเปลี่ยนเฉพาะส่วนที่ต้องการ โดยใช้คำสั่ง copy
//       book = book.copy(
//         title: book.title+' new ',
//         price: 30.00,
//         in_stock: true,
//         num_pages: 300,
//         publication_date: DateTime.now()
//       );      
//       await _db.update(book); // ทำคำสั่งอัพเดทข้อมูล
//       setState(() {
//         books = _db.readAllBook(); // แสดงรายการหนังสือ
//       });    
//     }    
  
//     // จำลองทำคำสั่งเพิ่มข้อมูลใหม่
//     Future<void> newBook() async {
//       i++;
//       Book book = Book(
//         book_id: i,
//         title: 'Book title $i',
//         price: 20.00,
//         in_stock: true,
//         num_pages: 200,
//         publication_date: DateTime.now()
//       );
//       await _db.create(book); // ทำคำสั่งเพิ่มข้อมูลใหม่
//       setState(() {
//         books = _db.readAllBook(); // แสดงรายการหนังสือ
//       });
//     }
  
//     @override
//     Widget build(BuildContext context) {
//         return Scaffold(
//             appBar: AppBar(
//                 title: Text('Book'),
//                 actions: <Widget>[ // 
//                   IconButton(
//                     onPressed: () => clearBook(), // ปุ่มลบข้อมูลทั้งหมด
//                     icon: const Icon(Icons.clear_all),
//                   ),
//                 ],
//             ),
//             body: Center(
//               child: FutureBuilder<List<Book>>( // ชนิดของข้อมูล
//                 future: books, // ข้อมูล Future
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                       return Column(
//                           children: [
//                             Expanded( // ส่วนของลิสรายการ
//                                 child: snapshot.data!.isNotEmpty // กำหนดเงื่อนไขตรงนี้
//                                 ? ListView.separated( // กรณีมีรายการ แสดงปกติหนด controller ที่จะใช้งานร่วม
//                                         itemCount: snapshot.data!.length,
//                                         itemBuilder: (context, index) {
//                                           Book book = snapshot.data![index];
  
//                                           Widget card; // สร้างเป็นตัวแปร
//                                           card = Card(
//                                             margin: const EdgeInsets.all(5.0), // การเยื้องขอบ
//                                             child: Column(
//                                               children: [
//                                                 ListTile(
//                                                   leading: IconButton(
//                                                     onPressed: () => editBook(book), // จำลองแก้ไขข้อมูล
//                                                     icon: const Icon(Icons.edit),
//                                                   ),
//                                                   title: Text(book.title),
//                                                   subtitle: Text('Date: ${dateFormat.format(book.publication_date)}'),
//                                                   trailing: IconButton(
//                                                     onPressed: () => deleteBook(book.id!), // ลบข้อมูล
//                                                     icon: const Icon(Icons.delete),
//                                                   ),
//                                                   onTap: (){
//                                                      _viewDetail(book.id!); // กดเลือกรายการให้แสดงรายละเอียด                                           
//                                                   },
//                                                 ),
//                                               ],
//                                             )
//                                           );
//                                           return card;
//                                         },
//                                         separatorBuilder: (BuildContext context, int index) => const SizedBox(),
//                                 )
//                                 : const Center(child: Text('No items')), // กรณีไม่มีรายการ
//                             ),
//                           ],
//                         );
//                   } else if (snapshot.hasError) { // กรณี error
//                     return Text('${snapshot.error}');
//                   }
//                   // กรณีสถานะเป็น waiting ยังไม่มีข้อมูล แสดงตัว loading
//                  return const RefreshProgressIndicator();
//                 },
//               ),  
//             ),  
//             floatingActionButton: FloatingActionButton(
//               onPressed: () => newBook(),
//               child: const Icon(Icons.add),
//             ),
//         );
//     }
  
//     // สร้างฟังก์ชั่นจำลองการแสดงรายละเอียดข้อมูล
//     Future<Widget?> _viewDetail(int id) async {
//       Future<Book> book = _db.readBook(id); // ดึงข้อมูลจากฐานข้อมูลมาแสดง
//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context){
//             return FutureBuilder<Book>(
//               future: book,
//               builder: (context,snapshot){
//                 if (snapshot.hasData) {
//                   var book = snapshot.data!;
//                   return Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 200,
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ID: ${book.id}'),
//                         SizedBox(height: 5,),
//                         Text('ชื่อหนังสือ: ${book.title}'),
//                         SizedBox(height: 5,),
//                         Text('รหัส: ${book.book_id}'),
//                         SizedBox(height: 5,),
//                         Text('ราคา: ${book.price}'),
//                         SizedBox(height: 5,),
//                         Text('จำนวนหน้า: ${book.num_pages}'),
//                         SizedBox(height: 5,),
//                         Text('มีในคลัง: ${ book.in_stock ? 'มี' : 'ไม่มี'}'),
//                         SizedBox(height: 5,),
//                         Text('วันที่: ${dateFormat.format(book.publication_date)}'),
//                       ],
//                     ),
//                   );
//                 } else if (snapshot.hasError) { // กรณี error
//                   return Text('${snapshot.error}');
//                 }
//                 return const RefreshProgressIndicator();
//               }
//             );
//         }
//       );
//       return null;
//     }
  
// }