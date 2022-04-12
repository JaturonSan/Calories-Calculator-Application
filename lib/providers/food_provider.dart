import 'package:flutter/cupertino.dart';
import 'package:mini_project/database/food_db.dart';
import 'package:mini_project/model/food.dart';

class FoodProvider with ChangeNotifier {
  // 1.สร้างลิสของ Food 
  List<Foods> foods = [];
  int cals = 0;

  // สร้างฟังชั่นเรียก Foods
  List<Foods> getFood(){
    return foods;
  }

  // ฟังก์ชั่นเพิ่ม Food
  void addFood(Foods statement) async {
    var db =  FoodDB(dbName: "foods.db");
    // บันทึกข้อมูล
    await db.insertData(statement);

    // ดึงข้อมูลมาแสดงผล(Select)
    foods = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }

  // ฟังก์ชั่นในการโหลดข้อมูลขึ้นมาก่อนแสดงหน้าแอป
  void initData() async {
    var db = FoodDB(dbName: "foods.db");
    // ดึงข้อมูลมาแสดงผล (Select)
    foods = await db.loadAllData();
    notifyListeners();
  }

  // ฟังก์ชั่นในการดึงค่าแคลลอรี่ของอาหารจากฐานข้อมูลที่เพิ่มเข้ามา
  Future<int> loadCals() async {
    var db = FoodDB(dbName: "foods.db");
    // ดึงข้อมูลมาแสดงผล (Select)
    cals = await db.loadCalsData();
    notifyListeners();
    return cals;
  }

  // ลบข้อมูลเฉพาะที่เลือกไว้เท่านั้น
  void deleteFood(Foods statement) async {
    var db =  FoodDB(dbName: "foods.db");
    await db.deleteFood(statement);
    // ดึงข้อมูลมาแสดงผล(Select)
    foods = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }

  // ฟังก์ชั่นในการลบข้อมูลทั้งหมดในฐานข้อมูล foods.db
  void deleteAllData() async {
    FoodDB db = FoodDB(dbName: "foods.db");
    await db.deleteAll();

    // เตือน Consumer
    notifyListeners();
  }

  // ฟังก์ชั่นในการแก้ไขข้อมูล
  void editData(Foods statement, Foods newData) async {
    var db =  FoodDB(dbName: "foods.db");
    await db.editData(statement, newData);

    // เตือน Consumer
    notifyListeners();
  }
}