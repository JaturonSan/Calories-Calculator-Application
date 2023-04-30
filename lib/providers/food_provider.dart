import 'package:flutter/cupertino.dart';
import 'package:mini_project/database/food_db.dart';
import 'package:mini_project/model/food.dart';

class FoodProvider with ChangeNotifier {
  // 1.สร้างลิสของ Food 
  List<Foods> foods = [];
  List values = [];

  // สร้างฟังชั่นเรียก Foods
  List<Foods> getFood(){
    return foods;
  }

  // ฟังก์ชั่นเพิ่ม Food
  void addFood(Foods statement, String dbName) async {
    var db =  FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    // บันทึกข้อมูล
    await db.insertData(statement);

    // ดึงข้อมูลมาแสดงผล(Select)
    foods = await db.loadAllData();

    // เตือน Consumer
    //notifyListeners();
  }

  // ฟังก์ชั่นในการโหลดข้อมูลขึ้นมาก่อนแสดงหน้าแอป
  void initData(String dbName) async {
    var db = FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    // ดึงข้อมูลมาแสดงผล (Select)
    foods = await db.loadAllData();
    notifyListeners();
  }

  // ฟังก์ชั่นในการดึงค่าแคลลอรี่ของอาหารจากฐานข้อมูลที่เพิ่มเข้ามา
  Future<List> loadCals(String dbName) async {
    var db = FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    // ดึงข้อมูลมาแสดงผล (Select)
    values = await db.loadCalsData();
    notifyListeners();
    return values;
  }

  // ลบข้อมูลเฉพาะที่เลือกไว้เท่านั้น
  void deleteFood(Foods statement, String dbName) async {
    var db =  FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    await db.deleteFood(statement);
    // ดึงข้อมูลมาแสดงผล(Select)
    foods = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }

  // ฟังก์ชั่นในการลบข้อมูลทั้งหมดในฐานข้อมูล foods.db
  void deleteAllData(String dbName) async {
    FoodDB db = FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    await db.deleteAll();

    // เตือน Consumer
    notifyListeners();
  }

  // ฟังก์ชั่นในการแก้ไขข้อมูล
  void editData(Foods statement, Foods newData, String dbName) async {
    var db =  FoodDB(dbName: dbName); // ฐานข้อมูลของอาหารทั้งหมด ไม่ใช้อาหารของ users
    await db.editData(statement, newData); // "foods.db"

    // เตือน Consumer
    notifyListeners();
  }
}