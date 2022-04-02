import 'package:flutter/cupertino.dart';
import 'package:mini_project/database/food_db.dart';
import 'package:mini_project/model/food.dart';

class FoodProvider with ChangeNotifier {
  // 1.สร้างลิสของ Food 
  List<Foods> foods = [];

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

  void initData() async {
    var db = FoodDB(dbName: "foods.db");
    // ดึงข้อมูลมาแสดงผล (Select)
    foods = await db.loadAllData();
    notifyListeners();
  }

  void deleteFood(Foods statement) async {
    var db =  FoodDB(dbName: "foods.db");
    await db.deleteFood(statement);
    // ดึงข้อมูลมาแสดงผล(Select)
    foods = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }
}
