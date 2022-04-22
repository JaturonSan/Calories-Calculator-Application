import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:provider/provider.dart';

class ShowFoodScreen extends StatefulWidget {
  const ShowFoodScreen({Key? key}) : super(key: key);

  @override
  _ShowFoodScreenState createState() => _ShowFoodScreenState();
}

class _ShowFoodScreenState extends State<ShowFoodScreen> {
  final keyForm = GlobalKey<FormState>();

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    //provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
    provider.initData("user_foods.db"); // init ข้อมูลอาหารของ user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    trailing: SizedBox(
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
                              TextEditingController proController = TextEditingController(text: (data.protein).toString());
                              TextEditingController amountController = TextEditingController(text: (data.amount).toString());
                              TextEditingController gramController = TextEditingController(text: (data.gram).toString());
                              TextEditingController picController = TextEditingController(text: data.pic);
                              await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('แก้ไขข้อมูล'),
                                  content: Form(
                                    key: keyForm,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.name,
                                            controller: nameController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'ชื่ออาหาร',
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextFormField(
                                            controller: calController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'แคลอรี่ (ต่อ 100 กรัม)',
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextFormField(
                                            controller: proController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาป้อนจำนวนโปรตีน'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'โปรตีน',
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextFormField(
                                            keyboardType: TextInputType.visiblePassword,
                                            controller: amountController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาใส่จำนวนอาหาร'),
                                              MinLengthValidator(1, errorText: 'จำนวนอาหารต้องมีอย่างน้อย 1 จาน'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'จำนวน',
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextFormField(
                                            keyboardType: TextInputType.visiblePassword,
                                            controller: gramController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาใส่น้ำหนักอาหาร'),
                                              MinLengthValidator(1, errorText: 'น้ำหนักอาหารต้องมีอย่างน้อย 100 กรัม'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'กี่กรัม',
                                            ),
                                          ),
                                          const SizedBox(height: 20,),
                                          TextFormField( // แก้ไขที่อยู่ของรูปภาพได้นะ
                                            keyboardType: TextInputType.name,
                                            controller: picController,
                                            validator: MultiValidator([
                                              RequiredValidator(errorText: 'กรุณาใส่รูปอาหาร'),
                                            ]),
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'จำนวน',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                      onPressed: () async { 
                                        // ค่าที่แก้ไขใน dialog จะเก็บในตัวแปรนี้
                                        var name = nameController.text;
                                        var cal = int.parse(calController.text);
                                        var pro = int.parse(proController.text);
                                        var amout = int.parse(amountController.text);
                                        var gram = int.parse(gramController.text);
                                        var pic = picController.text;
                                        Foods foods = Foods(name: name,calories: cal,protein: pro,amount: amout,gram: gram,pic: pic);

                                        // แก้ไขข้อมูลในฐานข้อมูล
                                        var provider = Provider.of<FoodProvider>(context, listen: false);
                                        //provider.editData(data, foods, "foods.db"); // แก้ไขฐานข้อมูลของอาหารในฐานข้อมูลเรา
                                        provider.editData(data, foods, "user_foods.db"); // แก้ไขฐานข้อมูลของ user
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MainScreen(Text("อาหาร"), ShowFoodScreen(), 2)), // this mainpage is your page to refresh
                                          (Route<dynamic> route) => false,
                                        );
                                      },
                                      icon: const Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              );
                            }, 
                            icon: const Icon(Icons.edit)
                          ),
                          IconButton(
                            onPressed: () async {
                              // ลบข้อมูลในฐานข้อมูลโดย เรียกฟังก์ชั่น DeleteFood ใน FoodDB แล้วใส่ข้อมูลตัวที่จะลบลงไป
                              var provider = Provider.of<FoodProvider>(context, listen: false);
                              //provider.deleteFood(data, "foods.db"); // ลบอาหารในฐานข้อมูลของเรา
                              provider.deleteFood(data, "user_foods.db"); // ลบอาหารในฐานข้อมูลของ user
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MainScreen(Text("อาหาร"), ShowFoodScreen(), 2)), // this mainpage is your page to refresh
                                (Route<dynamic> route) => false,
                              );
                            }, 
                            icon: const Icon(Icons.delete)
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