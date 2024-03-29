import 'dart:io';
import 'package:mini_project/model/food.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FoodDB{
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
      "protien": statement.protein,
      "fat": statement.fat,
      "carb": statement.carb,
      "amount": statement.amount,
      "gram": statement.gram,
      "type": statement.type,
      "pic": statement.pic
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
          calories: int.parse(record["calories"].toString()),
          protein: double.parse(record["protien"].toString()),
          fat: int.parse(record["fat"].toString()),
          carb: int.parse(record["carb"].toString()),
          amount: int.parse(record["amount"].toString()),
          gram: int.parse(record["gram"].toString()),
          type: record["type"].toString(),
          pic: record["pic"].toString()
        )
      );
    }
    return foodList;
  } 

  // ฟังก์ชั่นโหลดข้อมูลแคลลอรี่ในฐานข้อมูล
  Future<List> loadCalsData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    // การใส่ finder หมายถึงการเรียงข้อมูล จากน้อยไปมากและมากไปน้อย
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, true)]));
    double pros = 0;
    int carbs = 0;
    int fats = 0;
    int cals = 0;
    for(var record in snapshot){
      // โหลดข้อมูล calories มาคูณกับจำนวนที่ใส่ในฐานข้อมูล 
      cals+=((int.parse(record["gram"].toString())*(int.parse(record["calories"].toString())/100))*int.parse(record["amount"].toString())).round();
      pros+=(int.parse(record["gram"].toString())*double.parse(record["protien"].toString())/100)*int.parse(record["amount"].toString());
      carbs+=((int.parse(record["gram"].toString())*double.parse(record["carb"].toString())/100)*int.parse(record["amount"].toString())).round();
      fats+=((int.parse(record["gram"].toString())*double.parse(record["fat"].toString())/100)*int.parse(record["amount"].toString())).round();
    }
    return [cals,pros,carbs,fats];
  }

  // ฟังก์ชั่นในการหารายการอาหารตามแท็ก เช่น ต้องการหาอาหารที่เป็นเครื่องดื่มเท่านั้น
  Future<List<Foods>> searchData(String foodType) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    // การใส่ finder หมายถึงการเรียงข้อมูล จากน้อยไปมากและมากไปน้อย
    var snapshot = await store.find(
      db, 
      finder: Finder(
        sortOrders: [SortOrder(Field.key, true)],
        filter: Filter.and([
          Filter.equals("type", foodType),
        ]),
      ),
    );
    List<Foods> foodList = [];
    for(var record in snapshot){
      foodList.add(
        Foods(
          name: record["name"].toString(),
          calories: int.parse(record["calories"].toString()),
          protein: double.parse(record["protien"].toString()),
          amount: int.parse(record["amount"].toString()),
          carb: int.parse(record["carb"].toString()),
          fat: int.parse(record["carb"].toString()),
          gram: int.parse(record["gram"].toString()),
          type: record["type"].toString(),
          pic: record["pic"].toString()
        )
      );
    }
    return foodList;
  }

  Future deleteFood(Foods statement) async {
    // เพิ่มการลบข้อมูลเดี่ยวบน record 
    var db = await openDatabase();
    var store = intMapStoreFactory.store();
    await store.delete(
      db, 
      finder: Finder(
        filter: Filter.and([
          Filter.equals("name", statement.name),
          Filter.equals("calories", statement.calories),
          Filter.equals("protien", statement.protein),
          Filter.equals("amount", statement.amount),
          Filter.equals("carb", statement.carb),
          Filter.equals("fat", statement.fat),
          Filter.equals("type", statement.type),
          Filter.equals("gram", statement.gram),
        ]),
      )
    ); // store.delete() คำสั่งในการลบโดยใช้ finder ในการหา record ที่ต้องการลบ
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
        "protien": newData.protein,
        "carb": newData.carb,
        "fat": newData.fat,
        "amount": newData.amount,
        "gram": newData.gram,
        "type": newData.type,
        "pic": newData.pic
      },
    );
  }
}