import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/model/food.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/showfoodscreen_2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/food_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({ Key? key }) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  Color backgroundColor = Colors.cyan[900]!;
  Color buttonColor = Colors.red;
  Color buttonTextColor = Colors.black;
  Color fontColor = Colors.black;
  Color selectedTabbarColor = Colors.white;
  // ตัวแปรเก็บ tabBar
  late TabBar _tabBar;

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
    _tabBar = TabBar(
      labelColor: fontColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelColor: fontColor,
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      indicator: BoxDecoration(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(30),),
        color: selectedTabbarColor,
        // border: Border(
        //   bottom: BorderSide(width: 1),
        // )
      ),
      tabs: const [
        Tab(text: 'กินอาหาร', ),
        Tab(text: 'เพิ่มรายการอาหาร'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Material(
                color: backgroundColor,
                child: _tabBar,
              ),
            ),
          body: const TabBarView(
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
  // ขนาดตัวหนังสือในรายการอาหาร
  double fontSize = 12.0;
  // สีตัวหนังสือ
  Color? fontColor = Colors.white;
  final formKey = GlobalKey<FormState>();
  // สีของปุ่ม
  Color buttonColor = Colors.red;
  Color buttonTextColor = Colors.black;
  double buttonFontSize = 13.0;
  bool onSearch = false;
  List foodData = [];
  String foodTypeSearchText = 'กดเพื่อค้นหาอาหาร';
  // ข้อมูลประเภทอาหารที่จะขึ้นบน dropdownButton
  List<String> foodType = ['ทั้งหมด','อาหารคาว','ของหวาน','ของว่าง','อาหารกระป๋อง','เครื่องดื่ม'];
  List<ListTile> foodTypeListTile = [];
  List<Widget> foodTypeButtonList = [];

  BoxDecoration dropdownStyle = BoxDecoration(
    color: const Color.fromRGBO(21, 96, 189, 1.0),
    borderRadius: BorderRadius.circular(15),
  );
  // style ของ dropdown
  TextStyle dropdownText = const TextStyle(
    fontSize: 17,
    color: Colors.white,
  );
  String? _foodTypeButton = 'อาหารคาว';
  // dropdownColor 
  Color dropdownColor = const Color.fromRGBO(47, 186, 199, 1.0);
  // dropdown border
  BorderRadius dropdownborder = const BorderRadius.all(Radius.circular(20));
  File? image; // รูปภาพอาหารที่มาจากการถ่ายรูปหรือเลือกจากคลังรูปภาพ
  String picLocation = ""; // ที่อยู่รูปอาหาร
  late TextEditingController picController = TextEditingController();

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

  Future<Color> getButtonColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      buttonColor = Color(int.parse(sharedpreferences.getString('AppButtonColor')!, radix: 16,));
      buttonTextColor = Color(int.parse(sharedpreferences.getString('AppButtonTextColor')!, radix: 16,));
    });
    return buttonColor;
  }

  // เรียกประเภทอาหารใส่ใน ListTile ใส่ใน list แล้วแสดงผล
  void getFoodType() async {
    foodTypeListTile = [];
    foodType.forEach(
      (item) { 
        foodTypeListTile.add(
          ListTile(
            title: Text(item),
            onTap: () {
              if(item != "ทั้งหมด") {
                var provider = Provider.of<FoodProvider>(context, listen: false);
                provider.searchFoods(item, "foods.db");
                setState(() {
                  onSearch = false;
                  foodTypeSearchText = item;
                });
              } else {
                var provider = Provider.of<FoodProvider>(context, listen: false);
                provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
                setState(() {
                  onSearch = false;
                  foodTypeSearchText = item;
                });
              }
            },
          ),
        );
      }
    );
  }

  // เรียกปุ่มที่เอาไว้ค้นหาอาหาร
  void getFoodTypeButton() async {
    buttonColor = await getButtonColor();

    foodTypeButtonList = [];
    foodType.forEach(
      (item) {
        foodTypeButtonList.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if(item != "ทั้งหมด") {
                var provider = Provider.of<FoodProvider>(context, listen: false);
                provider.searchFoods(item, "foods.db");
              } else {
                var provider = Provider.of<FoodProvider>(context, listen: false);
                provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
              }
            }, 
            child: Text(item, style: TextStyle(fontSize: buttonFontSize, color: buttonTextColor),),
          ),
        );
        foodTypeButtonList.add(const SizedBox(height: 10,width: 5,));
      }
    );
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
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    var provider = Provider.of<FoodProvider>(context, listen: false);
    provider.initData("foods.db"); // init ข้อมูลอาหารของเรา
    //provider.initData("user_foods.db"); // init ข้อมูลอาหารของ user
    getFoodTypeButton();
  }

  @override
  Widget build(BuildContext context) {
    // หน้านี้ไปทำต่อนะ ช่องค้นหาอาหาร แท็กแยกหมวหมู่อาหารและแสดงรายการอาหารที่จะใส่
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // กล่องค้นหารายการอาหาร
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // ช่องค้นหาอาหาร
                      ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(foodTypeSearchText),
                        onTap: () async {
                          getFoodType();
                          setState(() {
                            onSearch = true;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black26, width: 2,),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Stack(
                        fit: StackFit.loose,
                        children: [
                          // กดจำแนกกลุ่มอาหาร
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: foodTypeButtonList,
                            ),
                          ),
                          onSearch?
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0.5,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: foodTypeListTile,
                            ),
                          )
                          : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
           
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
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0),)),
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.add), 
                                          title: const Text('เพิ่มอาหาร'), 
                                          onTap: () async {
                                            // แจ้งเตือนผู้ใช้ว่าต้องการแก้ไขจะลบข้อมูลอาหารหรือไม่
                                            getAppColor();

                                            TextEditingController amountController = TextEditingController(text: data.amount.toString());
                                            TextEditingController gramController = TextEditingController(text: data.gram.toString());

                                            await showDialog<String>( 
                                              /* ตอนที่เลือกเพศมันมีปัญหากับ showDialog ตรงที่ว่ามันไม่ยอมขึ้น seleted สีฟ้า
                                                เราได้แก้ปัญหาโดยใช้ StreamBuilder ในการเช็คว่ามีการส่ง stream มาไหม
                                                จะได้เปลี่ยนแปลง UI 
                                                -- https://stackoverflow.com/questions/53123244/change-alertdialog-title-dynamically-showdialog
                                              */
                                              context: context,
                                              // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('แก้ไขข้อมูล'),
                                                  content: Form(
                                                    key: keyForm,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Text('ชื่ออาหาร: ${data.name}'),
                                                          box,
                                                          TextFormField(
                                                            keyboardType: TextInputType.number,
                                                            controller: amountController,
                                                            validator: MultiValidator([
                                                              RequiredValidator(errorText: 'กรุณาป้อนจำนวนที่กิน'),
                                                            ]),
                                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                            decoration: InputDecoration(
                                                              border: border,
                                                              labelText: 'จำนวนจานหรือชิ้นที่กิน',
                                                            ),
                                                          ),
                                                          box,
                                                          TextFormField(
                                                            keyboardType: TextInputType.number,
                                                            controller: gramController,
                                                            validator: MultiValidator([
                                                              RequiredValidator(errorText: 'กรุณาป้อนน้ำหนักอาหารเป็นกรัม (1 จานเท่ากับ 100 กรัม)'),
                                                            ]),
                                                            // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                            decoration: InputDecoration(
                                                              border: border,
                                                              labelText: 'น้ำหนักอาหาร',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    IconButton(
                                                      onPressed: () async { 
                                                        if(keyForm.currentState!.validate()){
                                                          Foods foods = Foods(name: data.name,calories: int.parse(data.calories.toString()),protein: double.parse(data.protein.toString()),carb: int.parse(data.carb.toString()),fat: int.parse(data.fat.toString()),amount: int.parse(amountController.text),gram: int.parse(gramController.text),pic: data.pic, type: data.type,);
                                                          var provider = Provider.of<FoodProvider>(context, listen: false);
                                                          provider.addFood(foods, "user_foods.db");
                                                          // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
                                                          Fluttertoast.showToast(
                                                            msg: "เพิ่ม ${data.name} สำเร็จ",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0
                                                          );
                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                            builder: (context) {
                                                                return MainScreen(const Text("อาหาร"), const ShowFoodScreen2(), 2, backgroundColor);
                                                              },
                                                            ),
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
                                                );
                                              }
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.edit), 
                                          title: const Text('แก้ไขอาหาร'), 
                                          onTap: () async {
                                            TextEditingController nameController = TextEditingController(text: data.name.toString());
                                            TextEditingController calController = TextEditingController(text: data.calories.toString());
                                            TextEditingController proController = TextEditingController(text: data.protein.toString());
                                            TextEditingController carbController = TextEditingController(text: data.carb.toString());
                                            TextEditingController fatController = TextEditingController(text: data.fat.toString());
                                            TextEditingController amountController = TextEditingController(text: data.amount.toString());
                                            TextEditingController gramController = TextEditingController(text: data.gram.toString());
                                            TextEditingController picController = TextEditingController(text: data.pic);
                                            image = File(data.pic.toString());

                                            await showDialog<String>( 
                                              /* ตอนที่เลือกเพศมันมีปัญหากับ showDialog ตรงที่ว่ามันไม่ยอมขึ้น seleted สีฟ้า
                                                เราได้แก้ปัญหาโดยใช้ StreamBuilder ในการเช็คว่ามีการส่ง stream มาไหม
                                                จะได้เปลี่ยนแปลง UI 
                                                -- https://stackoverflow.com/questions/53123244/change-alertdialog-title-dynamically-showdialog
                                              */
                                              context: context,
                                              // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('แก้ไขข้อมูล'),
                                                  content: Form(
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    IconButton(
                                                      onPressed: () async { 
                                                        if(keyForm.currentState!.validate()){
                                                          // ค่าที่แก้ไขใน dialog จะเก็บในตัวแปรนี้
                                                          Foods foods = Foods(name: nameController.text,calories: int.parse(calController.text),protein: double.parse(proController.text),carb: int.parse(carbController.text),fat: int.parse(fatController.text),amount: int.parse(amountController.text),gram: int.parse(gramController.text),type: _foodTypeButton,pic: picController.text);

                                                          getAppColor();

                                                          // แก้ไขข้อมูลในฐานข้อมูล
                                                          var provider = Provider.of<FoodProvider>(context, listen: false);
                                                          provider.editData(data, foods, "foods.db"); // แก้ไขฐานข้อมูลของอาหารในฐานข้อมูลเรา
                                                          provider.editData(data, foods, "user_foods.db"); // แก้ไขฐานข้อมูลของ user
                                                          // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
                                                          Fluttertoast.showToast(
                                                            msg: "แก้ไข ${data.name} สำเร็จ",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.CENTER,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0
                                                          );
                                                          Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>MainScreen(const Text("อาหาร"), const ShowFoodScreen2(), 2, backgroundColor)
                                                            ), // this mainpage is your page to refresh
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
                                                );
                                              }
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete), 
                                          title: const Text('ลบอาหาร'), 
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                    height: 200,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width / 2 - 32, // minus 32 due to the margin
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: Colors.yellow[100], // background color of the cards
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                boxShadow: const [
                                  // this is the shadow of the card
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0.2,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // posion the everything to the bottom
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  data.pic.toString()==''? Image.asset('assets/icons/no-image.png', height: 110,width: 110,) : Image.file(File(data.pic.toString()), height: 110,width: 110,),
                                  const SizedBox(height: 10,),
                                  Text(data.name.toString(), style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,),),
                                  Text(data.calories.toString()+" แคล", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold,)),
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
  final carbController = TextEditingController();
  final fatController = TextEditingController();
  final amountController = TextEditingController();
  final gramController = TextEditingController();
  late TextEditingController picController = TextEditingController();
  SizedBox box = const SizedBox(width: 10, height: 10,);
  BoxDecoration dropdownStyle = BoxDecoration(
    color: const Color.fromRGBO(21, 96, 189, 1.0),
    borderRadius: BorderRadius.circular(15),
  );
  // style ของ dropdown
  TextStyle dropdownText = const TextStyle(
    fontSize: 17,
    color: Colors.white,
  );
  String? _foodTypeButton = 'อาหารคาว';
  // dropdownColor 
  Color dropdownColor = const Color.fromRGBO(47, 186, 199, 1.0);
  // dropdown border
  BorderRadius dropdownborder = const BorderRadius.all(Radius.circular(20));
  int dropdownIndex = 1;
  // ข้อมูลประเภทอาหารที่จะขึ้นบน dropdownButton
  List<String> foodType = ['อาหารคาว','ของหวาน','ของว่าง','อาหารกระป๋อง','เครื่องดื่ม'];
  Color buttonColor = Colors.red;
  Color buttonTextColor = Colors.black;

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

  void getAppColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      buttonColor = Color(int.parse(sharedpreferences.getString('AppButtonColor')!, radix: 16,));
      buttonTextColor = Color(int.parse(sharedpreferences.getString('AppButtonTextColor')!, radix: 16,));
    });
  }

  @override
  void initState() {
    super.initState();
    getAppColor();
    picController = TextEditingController(text: picLocation);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  validator: RequiredValidator(errorText: 'กรุณาป้อนชื่ออาหาร'),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่ออาหาร',
                    filled: true,
                    fillColor: Colors.white,
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
                    filled: true,
                    fillColor: Colors.white,
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
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                box,
                box,
                TextFormField(
                  controller: carbController,
                  validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนคาร์โบไฮเดรต'),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'คาร์โบไฮเดรต',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                box,
                box,
                TextFormField(
                  controller: fatController,
                  validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนไขมัน'),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ไขมัน',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                box,
                TextFormField(
                  controller: amountController,
                  validator: RequiredValidator(errorText: 'กรุณาป้อนจำนวนที่กิน'),
                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'จำนวนชิ้นหรือจาน',
                    filled: true,
                    fillColor: Colors.white,
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
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    onPressed: () {
                      if(keyForm.currentState!.validate()){
                        Foods foods = Foods(name: nameController.text,calories: int.parse(calController.text),protein: double.parse(proController.text),carb: int.parse(carbController.text),fat: int.parse(fatController.text),amount: int.parse(amountController.text),gram: 100,pic: picController.text==''? '' : picController.text,  type: _foodTypeButton,);
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
                    child: Text('ลงทะเบียน', style: TextStyle(color: buttonTextColor),),
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