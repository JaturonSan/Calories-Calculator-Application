import 'dart:io';

import 'package:mini_project/model/profile.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ProfileDB{
  /* เป็นคลาสที่เอาไว้เก็บฐานข้อมูลบนเครื่องที่ใช้ package ได้แก่ 
  sembast (จัดการฐานข้อมูล) 
  path_provider (ดึงตำแหน่งฐานข้อมูลบทเครื่อง) 
  path (อ้างอิงตำแหน่งที่เก็บฐานข้อมูล)
  */
  late String dbName; // ชื่อฐานข้อมูล

  /* ถ้า DB ยังไม่ถูกสร้างจะสร้าง DB อัตโนมัติ
  ถ้ามี DB อยู่แล้วจะเปิดขึ้นมาเลย */
  ProfileDB({required this.dbName});
  
  Future<Database> openDatabase() async {
    // 1.หา Directory ของแอป
    Directory appDirectory = await getApplicationDocumentsDirectory();
    // 2.กำหนดตำแหน่งฐานข้อมูลโดยเอาที่อยู่แอปตามด้วยชื่อฐานข้อมูล
    String dbLocation = join(appDirectory.path, dbName);
    // 3.สร้างฐานข้อมูล
    DatabaseFactory dbFactory = databaseFactoryIo;
    // เปิดฐานข้อมูลแล้วส่งฐานข้อมูล db ออกไป
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(Profile statement) async {
    /* เปิดฐานข้อมูล openDatabase ใส่ใน db 
      store คือ การระบุที่จัดเก็บข้อมูลในแอพว่าชื่ออะไร มีรูปแบบการจัดเก็บข้อมูลแบบใด 
      โดยใช้ intMapStoreFactory
    */ 
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
  
    /* add ค่าข้อมูลต่างๆในรูปแบบ json ลงฐานข้อมูล
    close db จากนั้น return keyID ของข้อมูลกลับมา */
    var keyID = store.add(db, {
      "user": statement.username,
      "password": statement.password,
    });
    db.close();
    return keyID;
  }

  Future<List<Profile>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    // การใส่ finder หมายถึงการเรียงข้อมูล จากน้อยไปมากและมากไปน้อย
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, true)]));
    List<Profile> profileList = [];
    for(var record in snapshot){
      profileList.add(
        Profile(
          username: record['username'].toString(),
          password: record['password'].toString(),
        )
      );
    }
    return profileList;
  } 
}