import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/showfoodscreen_2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/food.dart';
import '../providers/food_provider.dart';

class EditFoodScreen extends StatefulWidget {
  final Foods data; // การส่งค่าระหว่าง StatefulWidget
  const EditFoodScreen(this.data,{Key? key}) : super(key: key); // การส่งค่าระหว่าง StatefulWidget

  @override
  // ignore: no_logic_in_create_state
  State<EditFoodScreen> createState() => _EditFoodScreenState(data: data);
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  Foods data; // การส่งค่าระหว่าง StatefulWidget
  _EditFoodScreenState({required this.data});
  SizedBox box = const SizedBox(width: 10, height: 10,);
  final keyForm = GlobalKey<FormState>();
  OutlineInputBorder border = const OutlineInputBorder();
  File? image; // รูปภาพอาหารที่มาจากการถ่ายรูปหรือเลือกจากคลังรูปภาพ
  String picLocation = ""; // ที่อยู่รูปอาหาร
  late TextEditingController picController = TextEditingController();
  Color backgroundColor = Colors.cyan[900]!;
  Color buttonColor = Colors.red;
  Color buttonTextColor = Colors.black;
  BoxDecoration dropdownStyle = BoxDecoration(
    color: const Color.fromRGBO(21, 96, 189, 1.0),
    borderRadius: BorderRadius.circular(15),
  );
  // style ของ dropdown
  TextStyle dropdownText = const TextStyle(
    fontSize: 17,
    color: Colors.white,
  );
  // ข้อมูลประเภทอาหารที่จะขึ้นบน dropdownButton
  List<String> foodType = ['ทั้งหมด','อาหารคาว','ของหวาน','ของว่าง','อาหารกระป๋อง','เครื่องดื่ม'];
  String? _foodTypeButton = 'อาหารคาว';
  // dropdownColor 
  Color dropdownColor = const Color.fromRGBO(47, 186, 199, 1.0);
  // dropdown border
  BorderRadius dropdownborder = const BorderRadius.all(Radius.circular(20));

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

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
      buttonColor = Color(int.parse(sharedpreferences.getString('AppButtonColor')!, radix: 16,));
      buttonTextColor = Color(int.parse(sharedpreferences.getString('AppButtonTextColor')!, radix: 16,));
    });
  }

  @override
  void initState() {
    super.initState();
    getAppColor();
    if(data.pic.toString() != '') {
      picController = TextEditingController(text: picLocation);
      image = File(data.pic.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: data.name.toString());
    TextEditingController calController = TextEditingController(text: data.calories.toString());
    TextEditingController proController = TextEditingController(text: data.protein.toString());
    TextEditingController carbController = TextEditingController(text: data.carb.toString());
    TextEditingController fatController = TextEditingController(text: data.fat.toString());
    TextEditingController amountController = TextEditingController(text: data.amount.toString());
    TextEditingController gramController = TextEditingController(text: data.gram.toString());
    TextEditingController picController = TextEditingController(text: data.pic);

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูล'),
        backgroundColor: backgroundColor, 
        actions: [
          IconButton(
            onPressed: () async {
              // แจ้งเตือนผู้ใช้ว่าจะลบข้อมูลอาหารหรือไม่
              await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('จะลบอาหารหรือไม่'),
                  content: const Text("ถ้าดำเนินการต่อไปจะเป็นการลบข้อมูลอาหารนี้"),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        var provider = Provider.of<FoodProvider>(context, listen: false);
                        provider.deleteFood(data, "user_foods.db"); // ลบอาหารในฐานข้อมูลของ user
                      
                        // ใช้ refresh หน้านี้
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                              return const ShowFoodScreen2();
                            },
                          )
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
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: keyForm,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่ชื่ออาหาร'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'ชื่ออาหาร',
                    ),
                  ),
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: calController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่แคลลอรี่'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'แคลลอรี่',
                    ),
                  ),
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: proController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่โปรตีน'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'โปรตีน',
                    ),
                  ),
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: carbController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่คาร์โบไฮเดรต'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'คาร์โบไฮเดรต',
                    ),
                  ),
                  box,
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: fatController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่ไขมัน'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'ไขมัน',
                    ),
                  ),
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    validator: RequiredValidator(errorText: 'กรุณาใส่จำนวนอาหาร'),
                    // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                    decoration: InputDecoration(
                      border: border,
                      labelText: 'จำนวน',
                    ),
                  ),
                  box,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: dropdownStyle,
                    child: DropdownButton(
                      style: dropdownText,
                      items: foodType.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                          onTap: () {
                            // if(item["RepairedTypeName"] != "กรุณาเลือก") {
                            //   setState(() {
                            //     repairedTypeID = int.parse(item["RepairedTypeID"]);
                            //     dropdownIndex = 2;
                            //   });
                            // }
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _foodTypeButton = value.toString();
                        });
                      },
                      value: _foodTypeButton,
                      isExpanded: true,
                      autofocus: true,
                      dropdownColor: dropdownColor,
                      borderRadius: dropdownborder,
                      hint: Text('กรุณาเลือก', style: dropdownText),
                    ),
                  ),
                  box,
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: gramController,
                    validator: RequiredValidator(errorText: 'กรุณาป้อนน้ำหนักอาหาร'),
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
                image == null ? const SizedBox(height: 120,width: 120, child: Text('ไม่ได้เลือกรูปภาพ')) : Image.file(image!, height: 120, width: 120,),
                box,
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    onPressed: () {
                      if(keyForm.currentState!.validate()){
                        // ค่าที่แก้ไขใน dialog จะเก็บในตัวแปรนี้
                        Foods foods = Foods(name: nameController.text,calories: int.parse(calController.text),protein: double.parse(proController.text),carb: int.parse(carbController.text),fat: int.parse(fatController.text),amount: int.parse(amountController.text),gram: int.parse(gramController.text),type: _foodTypeButton,pic: picController.text);

                        getAppColor();

                        // แก้ไขข้อมูลในฐานข้อมูล
                        var provider = Provider.of<FoodProvider>(context, listen: false);
                        provider.editData(data, foods, "foods.db"); // แก้ไขฐานข้อมูลของอาหารในฐานข้อมูลเรา
                        provider.editData(data, foods, "user_foods.db"); // แก้ไขฐานข้อมูลของ user
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>MainScreen(const Text("อาหาร"), const ShowFoodScreen2(), 2, backgroundColor)
                          ), // this mainpage is your page to refresh
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Text('แก้ไข', style: TextStyle(color: buttonTextColor),),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}