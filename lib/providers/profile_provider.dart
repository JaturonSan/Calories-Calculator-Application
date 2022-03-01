import 'package:flutter/cupertino.dart';
import 'package:mini_project/database/profile_db.dart';
import 'package:mini_project/model/profile.dart';

class ProfileProvider with ChangeNotifier {
  // 1.สร้างลิสของ profile 
  List<Profile> profiles = [];

  // สร้างฟังชั่นเรียก profiles
  List<Profile> getProfile(){
    return profiles;
  }

  // ฟังก์ชั่นเพิ่ม profile
  void addProfile(Profile statement) async {
    var db =  ProfileDB(dbName: "profile.db");
    // บันทึกข้อมูล
    await db.insertData(statement);

    // ดึงข้อมูลมาแสดงผล(Select)
    profiles = await db.loadAllData();

    // เตือน Consumer
    notifyListeners();
  }

  void initData() async {
    var db = ProfileDB(dbName: "profile.db");
    // ดึงข้อมูลมาแสดงผล (Select)
    profiles = await db.loadAllData();
    notifyListeners();
  }
}
