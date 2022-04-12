import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/database/food_db.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/addfoodscreen.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:provider/provider.dart';

class ShowFoodScreen extends StatefulWidget {
  const ShowFoodScreen({Key? key}) : super(key: key);

  @override
  _ShowFoodScreenState createState() => _ShowFoodScreenState();
}

class _ShowFoodScreenState extends State<ShowFoodScreen> {
  FoodDB fooddb = FoodDB(dbName: "foods.db");
  final keyForm = GlobalKey<FormState>();

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    provider.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('รายการอาหาร'), 
        backgroundColor: Colors.cyan[900],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddFood();
              }));
            },
            icon: const Icon(Icons.fastfood),
          ),
          IconButton(
            onPressed: () {
              var provider = Provider.of<FoodProvider>(context, listen: false);
              // เรียกฟังก์ชั่นลบข้อมูลทั้งที่อยู่ในฐานข้อมูล NoSQL
              provider.deleteAllData();

              // ใช้ refresh หน้านี้
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ShowFoodScreen()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, FoodProvider provider, child) {
          var count = provider.foods.length;

          /*  เช็ค if -> else 
          1.ถ้า count <= 0 คือไม่มีข้อมูลจะแสดงข้อความว่าไม่มีข้อมูล
          2.ถ้าเป็นอย่างอื่นจะแสดงหน้าขึ้นมาพร้อมรายการอาหาร
           */
          if (count <= 0) {
            return const Center(
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(fontSize: 35),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.foods.length,
              itemBuilder: (context, int index) {
                Foods data = provider.foods[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: FittedBox(
                        child: Text(data.amount.toString() + " อัน"), // โชว์จำนวนอาหารกี่จาน / ชิ้น
                      ),
                    ),
                    title: Text(data.name!), // ชื่ออาหาร
                    subtitle: Text(data.calories.toString() + " แคล"), // จำนวนแคลลอรี่
                    trailing: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () async {
                              // pop-up ที่แสดงขึ้นมาให้แก้ไขข้อมูลได้ โดยใช้ showDialog
                              /* ในปัญหาของการที่ TextFormField แก้ไขพร้อมกันไม่ได้กับมีข้อความแสดงแต่แรก เราต้อง
                                 ใส่ค่าใน TextEditingController ตั้งแต่แรกเลยแล้วค่อยไปใส่ใน TextFormField
                              */
                              TextEditingController nameController = TextEditingController(text: data.name);
                              TextEditingController calController = TextEditingController(text: (data.calories).toString());
                              TextEditingController amountController = TextEditingController(text: (data.amount).toString());
                              await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('แก้ไขข้อมูล'),
                                  content: Form(
                                    key: keyForm,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: nameController,
                                          validator: MultiValidator([
                                            RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                                          ]),
                                          // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'ชื่ออาหาร',
                                          ),
                                          //initialValue: data.name,
                                        ),
                                        SizedBox(height: 20,),
                                        TextFormField(
                                          controller: calController,
                                          validator: MultiValidator([
                                            RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                                          ]),
                                          // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'แคลอรี่',
                                          ),
                                          //initialValue: (data.calories).toString(),
                                        ),
                                        SizedBox(height: 20,),
                                        TextFormField(
                                          keyboardType: TextInputType.visiblePassword,
                                          controller: amountController,
                                          validator: MultiValidator([
                                            RequiredValidator(errorText: 'กรุณาจำนวนอาหาร'),
                                            MinLengthValidator(1, errorText: 'จำนวนอาหารต้องมีอย่างน้อย 1 จาน'),
                                          ]),
                                          // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'จำนวน',
                                          ),
                                          //initialValue: (data.amount).toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () async { 
                                        // ค่าที่แก้ไขใน dialog จะเก็บในตัวแปรนี้
                                        var name = nameController.text;
                                        var cal = double.parse(calController.text);
                                        var amout = int.parse(amountController.text);
                                        Foods foods = Foods(name: name,calories: cal,amount: amout);

                                        // แก้ไขข้อมูลในฐานข้อมูล
                                        var provider = Provider.of<FoodProvider>(context, listen: false);
                                        provider.editData(data, foods);
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => ShowFoodScreen()), // this mainpage is your page to refresh
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      child: const Text('โอเค'),
                                    ),
                                  ],
                                ),
                              );
                            }, 
                            icon: Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              // ลบข้อมูลในฐานข้อมูลโดย เรียกฟังก์ชั่น DeleteFood ใน FoodDB แล้วใส่ข้อมูลตัวที่จะลบลงไป
                              var provider = Provider.of<FoodProvider>(context, listen: false);
                              provider.deleteFood(data);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => ShowFoodScreen()), // this mainpage is your page to refresh
                                (Route<dynamic> route) => false,
                              );
                            }, 
                            icon: Icon(Icons.delete)
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }, 
      ),
    );
  }
}