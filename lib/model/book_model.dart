// กำหนดชื่อตารางไว้ในตัวแปร
final String tableBooks = 'books';
 
// กำหนดฟิลด์ข้อมูลของตาราง
class BookFields {
  // สร้างเป็นลิสรายการสำหรับคอลัมน์ฟิลด์
  static final List<String> values = [
    id, book_id, title, price, in_stock, num_pages, publication_date
  ];
 
  // กำหนดแต่ละฟิลด์ของตาราง ต้องเป็น String ทั้งหมด
  static final String id = '_id'; // ตัวแรกต้องเป็น _id ส่วนอื่นใช้ชื่อะไรก็ได้
  static final String book_id = 'book_id';
  static final String title = 'title';
  static final String price = 'price';
  static final String in_stock = 'in_stock';
  static final String num_pages = 'num_pages';
  static final String publication_date = 'publication_date';
}
 
// ส่วนของ Data Model ของหนังสือ
class Book {
  final int? id; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
  final int book_id; 
  final String title;
  final double price;
  final bool in_stock;
  final int num_pages;
  final DateTime publication_date;
 
  // constructor
  const Book({
    this.id,
    required this.book_id,
    required this.title,
    required this.price,
    required this.in_stock,
    required this.num_pages,
    required this.publication_date,
  });
 
  // ฟังก์ชั่นสำหรับ สร้างข้อมูลใหม่ โดยรองรับแก้ไขเฉพาะฟิลด์ที่ต้องการ
  Book copy({
   int? id,
   int? book_id,
   String? title,
   double? price,
   bool? in_stock,
   int? num_pages,
   DateTime? publication_date,
  }) =>
    Book(
      id: id ?? this.id, 
      book_id: book_id ?? this.book_id,
      title: title ?? this.title,
      price: price ?? this.price,
      in_stock: in_stock ?? this.in_stock,
      num_pages: num_pages ?? this.num_pages,
      publication_date: publication_date ?? this.publication_date,
    );
 
  // สำหรับแปลงข้อมูลจาก Json เป็น Book object
  static Book fromJson(Map<String, Object?> json) =>  
    Book(
      id: json[BookFields.id] as int?,
      book_id: json[BookFields.book_id] as int,
      title: json[BookFields.title] as String,
      price: double.parse(json[BookFields.price] as String),
      in_stock: json[BookFields.in_stock] == 1,
      num_pages: json[BookFields.num_pages] as int,
      publication_date: DateTime.parse(json[BookFields.publication_date] as String),
    );
 
  // สำหรับแปลง Book object เป็น Json บันทึกลงฐานข้อมูล
  Map<String, Object?> toJson() => {
    BookFields.id: id,
    BookFields.book_id: book_id,    
    BookFields.title: title,
    BookFields.price: price,
    BookFields.in_stock: in_stock ? 1 : 0,
    BookFields.num_pages: num_pages,
    BookFields.publication_date: publication_date.toIso8601String(),
  };
 
 
}