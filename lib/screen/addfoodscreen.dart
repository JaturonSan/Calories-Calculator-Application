import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/showfoodscreen.dart';
import 'package:mini_project/screen/showfoodscreen_2.dart';
import 'package:provider/provider.dart';

import '../providers/food_provider.dart';

class AddFood extends StatefulWidget {
  const AddFood({ Key? key }) : super(key: key);

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String picLocation = ""; // ที่อยู่รูปอาหาร
  File? image; // รูปภาพอาหารที่มาจากการถ่ายรูปหรือเลือกจากคลังรูปภาพ
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final proController = TextEditingController();
  final amountController = TextEditingController();
  final gramController = TextEditingController();
  late TextEditingController picController = TextEditingController();
  FoodProvider foddProvider = FoodProvider();

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

   @override
  void initState() {
    super.initState();
    picController = TextEditingController(text: picLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
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
                    RequiredValidator(errorText: 'กรุณาจำนวนอาหาร'),
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
                    RequiredValidator(errorText: 'กรุณาน้ำหนักอาหาร'),
                    MinLengthValidator(1, errorText: 'น้ำหนักอาหารต้องมีอย่างน้อย 100 กรัม'),
                  ]),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'กี่กรัม',
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField( // เพิ่มฟิวเอาไว้ใส่รูป ในอนาคตจะมีการโหลดรูปจากเครื่องได้
                  readOnly: true,
                  showCursor: false,
                  enableInteractiveSelection: false,
                  controller: picController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาใส่รูป'),
                  ]),
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
                image == null ? const SizedBox(height: 120,width: 120, child: Text('กรุณาเลือกรูปภาพ')) : Image.file(image!, height: 120, width: 120,),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                    onPressed: () {
                      var name = nameController.text;
                      var cal = int.parse(calController.text);
                      var pro = double.parse(proController.text);
                      var amout = int.parse(amountController.text);
                      var gram = int.parse(gramController.text);
                      var pic = picController.text;
                      Foods foods = Foods(name: name,calories: cal,protein: pro,amount: amout,gram: gram,pic: pic);
                      var provider = Provider.of<FoodProvider>(context, listen: false);
                      provider.addFood(foods, "user_foods.db"); // เพิ่มฐานข้อมูลอาหารของ user 
                      //provider.addFood(foods, "foods.db"); // เพิ่มฐานข้อมูลอาหารของแอป ไว้ตอนเพิ่มอาหารแบบค้นหาได้เลย ไม่ต้องมานั่งพิมพ์

                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const MainScreen(Text("อาหาร"), ShowFoodScreen(), 2)),
                      );
                    }, 
                    child: const Text('ลงทะเบียน'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}