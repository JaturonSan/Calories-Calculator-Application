import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
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
  OutlineInputBorder border = const OutlineInputBorder();
  SizedBox box = const SizedBox(height: 20,);
  String picLocation = ""; // ที่อยู่รูปอาหาร
  File? image; // รูปภาพอาหารที่มาจากการถ่ายรูปหรือเลือกจากคลังรูปภาพ
  late TextEditingController picController = TextEditingController();
  String name = ""; // ชื่ออาหาร
  int cal = 0; // แคลลอรี่
  double pro = 0; // โปรตีน
  int amount = 0; // จำนวนจานอาหาร
  int gram = 0; // จำนวนกรัม
  String pic = "";

  // ฟังก์ชั่นเลือกรูปภาพจากคลังรูปภาพ
  Future pickImageGallery() async {
    try {
      // ใช้ image_picker -- https://pub.dev/packages/image_picker
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      
      // ถ้ารูปเป็น null จะ return ออกไปจากฟังก์ชั่นเลย
      if(image==null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        picLocation = image.path;
        picController = TextEditingController(text: picLocation);
      });
    } on PlatformException catch (e) {
      // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

  // ฟังก์ชั่นถ่ายรูปจากกล้อง
  Future pickImageCamera() async {
    try {
      // ใช้ image_picker -- https://pub.dev/packages/image_picker
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      
      // ถ้ารูปเป็น null จะ return ออกไปจากฟังก์ชั่นเลย
      if(image==null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        picLocation = image.path;
        picController = TextEditingController(text: picLocation);
      });
    } on PlatformException catch (e) {
      // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }

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
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                                          box,
                                          TextFormField(
                                            keyboardType: TextInputType.name,
                                            controller: nameController,
                                            validator: RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                                            onSaved: (value){
                                              name = value!;
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: border,
                                              labelText: 'ชื่ออาหาร',
                                            ),
                                          ),
                                          box,
                                          TextFormField(
                                            controller: calController,
                                            validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                                            onSaved: (value){
                                              cal = int.parse(value!);                                           
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: border,
                                              labelText: 'แคลอรี่ (ต่อ 100 กรัม)',
                                            ),
                                          ),
                                          box,
                                          TextFormField(
                                            controller: proController,
                                            validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนโปรตีน'),
                                            onSaved: (value){
                                              pro = double.parse(value!);
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: border,
                                              labelText: 'โปรตีน',
                                            ),
                                          ),
                                          box,
                                          TextFormField(
                                            keyboardType: TextInputType.visiblePassword,
                                            controller: amountController,
                                            validator: RequiredValidator(errorText: 'กรุณาใส่จำนวนอาหาร'),
                                            onSaved: (value){
                                              amount = int.parse(value!);
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: border,
                                              labelText: 'จำนวน',
                                            ),
                                          ),
                                          box,
                                          TextFormField(
                                            keyboardType: TextInputType.visiblePassword,
                                            controller: gramController,
                                            validator: RequiredValidator(errorText: 'กรุณาใส่น้ำหนักอาหาร'),
                                            onSaved: (value){
                                              gram = int.parse(value!);
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: border,
                                              labelText: 'กี่กรัม',
                                            ),
                                          ),
                                          box,
                                          TextFormField( // เพิ่มฟิวเอาไว้ใส่รูป ในอนาคตจะมีการโหลดรูปจากเครื่องได้
                                            readOnly: true,
                                            showCursor: false,
                                            enableInteractiveSelection: false,
                                            controller: picController,
                                            // validator: MultiValidator([
                                            //   RequiredValidator(errorText: 'กรุณาใส่รูป'),
                                            // ]),
                                            onSaved: (value) {
                                              pic = value!;
                                            },
                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(),
                                              labelText: 'รูปอาหาร',
                                              suffixIcon: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // เพิ่มบรรทัดเพื่อแก้ไขปัญหาข้อมความถูกไอคอนบัง
                                                mainAxisSize: MainAxisSize.min, // เพิ่มบรรทัดเพื่อแก้ไขปัญหาข้อมความถูกไอคอนบัง
                                                children: <Widget>[
                                                  // ปุ่มใช้กล้องในการถ่ายรูปเข้าแอป
                                                  IconButton(
                                                    onPressed: (){
                                                      pickImageCamera();
                                                    }, 
                                                    icon: const Icon(Icons.camera)
                                                  ),
                                                  // ปุ่มเลือกรูปภาพจากคลังรูปภาพ
                                                  IconButton(
                                                    onPressed: (){
                                                      pickImageGallery();
                                                    }, 
                                                    icon: const Icon(Icons.image_rounded)
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          image == null ? const SizedBox(height: 120,width: 120, child: Text('กรุณาเลือกรูปภาพ', style: TextStyle(fontSize: 15),)) : Image.file(image!, height: 120, width: 120,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                      onPressed: () async { 
                                        if(keyForm.currentState!.validate()){
                                          // ค่าที่แก้ไขใน dialog จะเก็บในตัวแปรนี้
                                          Foods foods = Foods(name: name,calories: cal,protein: pro,amount: amount,gram: gram,pic: pic);

                                          // แก้ไขข้อมูลในฐานข้อมูล
                                          var provider = Provider.of<FoodProvider>(context, listen: false);
                                          //provider.editData(data, foods, "foods.db"); // แก้ไขฐานข้อมูลของอาหารในฐานข้อมูลเรา
                                          provider.editData(data, foods, "user_foods.db"); // แก้ไขฐานข้อมูลของ user
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const MainScreen(Text("อาหาร"), ShowFoodScreen(), 2)), // this mainpage is your page to refresh
                                            (Route<dynamic> route) => false,
                                          );
                                        }
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