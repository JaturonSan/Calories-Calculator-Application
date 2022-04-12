import 'dart:io';
import 'package:mini_project/model/food.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FoodDB{

  // static final FoodDB _singleton = FoodDB._();

  // static FoodDB get instance => _singleton;

  // Completer<Database> _dbOpenCompeter;
  // FoodDB.();

  // Future<Database> get database async {
  //   if(_dbOpenCompeter == null){
  //     _dbOpenCompeter = Completer();
  //     _openDatabase();
  //   }

  //   return _dbOpenCompeter.future;
  // }

  // Future _openDatabase() async {
  //   final appDocumentDir = await getApplicationDocumentsDirectory();

  //   final dbPath = join(appDocumentDir.path, "demo.db");

  //   final database = await databaseFactoryIo.openDatabase(dbPath);
  //   _dbOpenCompeter.complete(database);
  // }

  /* เป็นคลาสที่เอาไว้เก็บฐานข้อมูลบนเครื่องที่ใช้ package ได้แก่ 
  sembast (จัดการฐานข้อมูล) 
  path_provider (ดึงตำแหน่งฐานข้อมูลบทเครื่อง) 
  path (อ้างอิงตำแหน่งที่เก็บฐานข้อมูล)
  */
  late String dbName; // ชื่อฐานข้อมูล

  /* ถ้า DB ยังไม่ถูกสร้างจะสร้าง DB อัตโนมัติ
  ถ้ามี DB อยู่แล้วจะเปิดขึ้นมาเลย */
  FoodDB({required this.dbName});
  
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

  Future<int> insertData(Foods statement) async {
    /* เปิดฐานข้อมูล openDatabase ใส่ใน db 
      store คือ การระบุที่จัดเก็บข้อมูลในแอพว่าชื่ออะไร มีรูปแบบการจัดเก็บข้อมูลแบบใด 
      โดยใช้ intMapStoreFactory
    */ 
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
  
    /* add ค่าข้อมูลต่างๆในรูปแบบ json ลงฐานข้อมูล
    close db จากนั้น return keyID ของข้อมูลกลับมา */
    var keyID = store.add(db, {
      "name": statement.name,
      "calories": statement.calories,
      "amount": statement.amount,
    });
    db.close();
    return keyID;
  }

  Future<List<Foods>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    // การใส่ finder หมายถึงการเรียงข้อมูล จากน้อยไปมากและมากไปน้อย
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, true)]));
    List<Foods> foodList = [];
    for(var record in snapshot){
      foodList.add(
        Foods(
          name: record["name"].toString(),
          calories: double.parse(record["calories"].toString()),
          amount: int.parse(record["amount"].toString()),
        )
      );
    }
    return foodList;
  } 

  Future deleteFood(Foods statement) async {
    // int? id = statement.id;
    // var db = await openDatabase();
    // var store = intMapStoreFactory.store();
    // var record = store.record(id!);
    // record.delete(db); // store.delete() คำสั่งในการลบ
  }

  Future deleteAll() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    await store.delete(db);
  }

  Future editData(Foods statement, Foods newData) async {
    // Use the main store for storing map data with an auto-generated
    // int key
    var db = await openDatabase();
    var store = intMapStoreFactory.store();

    // ทำเพื่อหา key ของข้อมูลที่เราจะอัพเดตข้อมูลนั้น โดยใช้ Filter เพื่อกรองเนื้อหาในฐานข้อมูลที่ต้องการ
    var filter = Filter.and([Filter.equals("name", statement.name),]);
    var key = await store.findKey(
      db, 
      finder: Finder(
        filter: filter,
      ),
    );

    var record = store.record(key!);
    await record.update(
      db, 
      {
        "name": newData.name,
        "calories": newData.calories,
        "amount": newData.amount
      },
    );
  }
}