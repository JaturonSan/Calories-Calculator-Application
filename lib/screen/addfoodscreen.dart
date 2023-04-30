import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/model/food.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/food_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({ Key? key }) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1),
                  )
                ),
                tabs: [
                  Tab(text: 'กินอาหาร',),
                  Tab(text: 'เพิ่มรายการอาหาร'),
                ],
              ),
            ),
          body: TabBarView(
            children: <Widget>[
              AddUserFood(),
              AddDBFood(),
            ],
          ),
        ),
      ), 
    );
  }
}

// หน้าการเพิ่มอาหารของผู้ใช้ที่เป็นหน้าค้นหาอาหาร แล้วเด้งหน้าขึ้นมาใส่จำนวนจานที่กินเฉยๆ ไม่ต้องมานั่งใส่โปรตีน กิโลแคลใหม่
class AddUserFood extends StatefulWidget {
  const AddUserFood({Key? key}) : super(key: key);

  @override
  State<AddUserFood> createState() => _AddUserFoodState();
}

class _AddUserFoodState extends State<AddUserFood> {
  SizedBox box = const SizedBox(width: 10, height: 10,);
  final keyForm = GlobalKey<FormState>();
  OutlineInputBorder border = const OutlineInputBorder();
  Color backgroundColor = Colors.cyan[900]!;

  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
  }

  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
    //provider.initData("user_foods.db"); // init ข้อมูลอาหารของ user
  }

  @override
  Widget build(BuildContext context) {
    // หน้านี้ไปทำต่อนะ ช่องค้นหาอาหาร แท็กแยกหมวหมู่อาหารและแสดงรายการอาหารที่จะใส่
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // กล่องค้นหารายการอาหาร
              const Text('data'),

              // กดจำแนกกลุ่ม
 
              box,
              // รายการอาหารเป็นกล่องสี่เหลี่ยมใช้ GridView
              Consumer(
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
                    return GridView.count(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: List.generate(provider.foods.length, (index) {
                        Foods data = provider.foods[index];
                        return GestureDetector(
                          onTap: (){
                            TextEditingController amountController = TextEditingController(text: data.amount.toString());
                            TextEditingController gramController = TextEditingController(text: data.gram.toString());
                            Foods foods = Foods(name: data.name,calories: int.parse(data.calories.toString()),protein: double.parse(data.protein.toString()),amount: int.parse(amountController.text),gram: int.parse(gramController.text),pic: data.pic);
                            var provider = Provider.of<FoodProvider>(context, listen: false);
                            provider.addFood(foods, "user_foods.db"); // เพิ่มฐานข้อมูลอาหารของ user
                            Fluttertoast.showToast(
                              msg: "เพิ่ม ${data.name} สำเร็จ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                          },
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                            margin: const EdgeInsets.all(12.0),
                          padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100], // background color of the cards
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                              boxShadow: const [
                                // this is the shadow of the card
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.5,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // posion the everything to the bottom
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.file(File(data.pic.toString()), height: 80,width: 80,),
                                Text(data.name.toString(), style: const TextStyle(fontSize: 10),),
                                Text(data.calories.toString()+" แคล", style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                }, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* หน้าเพิ่มรายการอาหารเข้าฐานข้อมูลของแอปพลิเคชั่น สมมุติว่าอาหารนี้ยังไม่มีในฐานข้อมูลเราก็เพิ่มฐานข้อมูลอาหารนั้นเข้าไป 
แล้วใส่รายละเอียดต่างๆลงไป
*/
class AddDBFood extends StatefulWidget {
  const AddDBFood({Key? key}) : super(key: key);

  @override
  State<AddDBFood> createState() => _AddDBFoodState();
}

class _AddDBFoodState extends State<AddDBFood> {
  String picLocation = ""; // ที่อยู่รูปอาหาร
  File? image; // รูปภาพอาหารที่มาจากการถ่ายรูปหรือเลือกจากคลังรูปภาพ
  final keyForm = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final proController = TextEditingController();
  final gramController = TextEditingController();
  late TextEditingController picController = TextEditingController();
  SizedBox box = const SizedBox(width: 10, height: 10,);

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                validator: RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ชื่ออาหาร',
                ),
              ),
              box,
              TextFormField(
                controller: calController,
                validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนแคลอรี่'),
                // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'แคลอรี่ (ต่อ 100 กรัม)',
                ),
              ),
              box,
              TextFormField(
                controller: proController,
                validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนโปรตีน'),
                // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'โปรตีน',
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
              image == null ? const SizedBox(height: 120,width: 120, child: Text('กรุณาเลือกรูปภาพ')) : Image.file(image!, height: 120, width: 120,),
              box,
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[900]),
                  onPressed: () {
                    if(keyForm.currentState!.validate()){
                      Foods foods = Foods(name: nameController.text,calories: int.parse(calController.text),protein: double.parse(proController.text),amount: 1,gram: 100,pic: picController.text);
                      var provider = Provider.of<FoodProvider>(context, listen: false);
                      //provider.addFood(foods, "user_foods.db"); // เพิ่มฐานข้อมูลอาหารของ user 
                      provider.addFood(foods, "foods.db"); // เพิ่มฐานข้อมูลอาหารของแอป ไว้ตอนเพิ่มอาหารแบบค้นหาได้เลย ไม่ต้องมานั่งพิมพ์
                    
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const AddFoodScreen()
                        ),
                      ); 
                    }
                  }, 
                  child: const Text('ลงทะเบียน'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}