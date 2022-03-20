import 'package:flutter/cupertino.dart';
import 'package:mini_project/database/student_db.dart';
import 'package:mini_project/model/student_intel.dart';

class StudentProvider with ChangeNotifier {
  // 1.สร้างลิสของ Food 
  List<Students> students = [];

  // สร้างฟังชั่นเรียก Foods
  List<Students> getStudent(){
    return students;
  }

  // ฟังก์ชั่นเพิ่ม Food
  void addStudent(Students statement) async {
    var db =  StudentDB(dbName: "students.db");
    // บันทึกข้อมูล
    await db.insertData(statement);

    // ดึงข้อมูลมาแสดงผล(Select)
    students = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }

  void initData() async {
    var db = StudentDB(dbName: "students.db");
    // ดึงข้อมูลมาแสดงผล (Select)
    students = await db.loadAllData();
    notifyListeners();
  }
}
