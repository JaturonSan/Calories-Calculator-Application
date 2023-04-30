/* หน้านี้เป็นหน้าแสดงแคลลอรี่ของคนๆนี้ */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCalScreen extends StatefulWidget {
  const ShowCalScreen({Key? key}) : super(key: key);

  @override
  State<ShowCalScreen> createState() => _ShowCalScreenState();
}

// ตัวแปรสำหรับตัวเลือกติ้กวงกลม
enum SingingCharacter { t1, t2, t3, t4, t5 }

class _ShowCalScreenState extends State<ShowCalScreen> {
  String name = ""; // ชื่อผู้ใช้
  double weight = 0; // น้ำหนัก
  int height = 0; // ส่วนสูง
  int age = 0; // อายุ
  String gender = ""; // เพศ

  int calsNow = 0; // Kcalลอรี่ที่เหลือในวันนี้ ต้องมาจากหน้าเพิ่มอาหารในฐานข้อมูล
  int selecCals = 0; // แคลลอรี่ที่เลือกไว้ในที่ติ้กเลือกว่าเราใช้ชีวิตยังไง
  int cals = 0; // Kcalเลอรี่ BMR
  int calNone = 0; // ไม่ออกกำลังกายเลย
  int cal_1to3day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 1-3 วันต่อสัปดาห์
  int cal_4to5day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 4-5 วันต่อสัปดาห์
  int cal_6to7day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 6-7 วันต่อสัปดาห์
  int cal_2perday = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 2 ครั้งต่อวัน
  int carb = 0; // คาร์โบไฮเดรตที่ usr ต้องการในแต่ละวัน
  int pro = 0; // โปรตีนที่ usr ต้องการในแต่ละวัน
  double userPro = 0; // ตัวแปรโปรตีนที่ user ใส่เข้ามาในหน้าเพิ่มอาหาร
  int fat = 0; // ไขมันที่ usr ต้องการในแต่ละวัน
  double circlePercent = 0;
  SizedBox box = const SizedBox(width: 10, height: 10,);
  TextStyle h1 = const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,);
  TextStyle h2 = const TextStyle(fontSize: 15, color: Color(0xFF616161), fontWeight: FontWeight.bold);
  TextStyle content1 = const TextStyle(fontSize: 15, color: Colors.black);
  TextStyle content2 = const TextStyle(fontSize: 12, color: Colors.black);
  final user = FirebaseAuth.instance; // ข้อมูลของ user ปัจจุบัน
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users'); // ฐานข้อมูล collection ชื่อ 'users'
  BorderRadius borderCircle = BorderRadius.circular(40.0);
  final keyForm = GlobalKey<FormState>();
  OutlineInputBorder border = const OutlineInputBorder();
  bool _genderSelected1 = false; // ตัวแปรเช็คเพศชาย
  bool _genderSelected2 = false; // ตัวแปรเช็คเพศหญิง
  CircleBorder circleBorder = const CircleBorder(side: BorderSide(color: Colors.blue,width: 2,)); // ขอบของ ChoiceChip
  TextStyle whiteTxt = const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold); // ตัวหนังสือบน ChoiceChip
  TextStyle blueTxt = const TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold); // ตัวหนังสือบน ChoiceChip
  late Color backgroundColor;

  // ตัวแปรสำหรับตัวเลือกติ้กวงกลม
  late SingingCharacter? _character = SingingCharacter.t1;

  void calRemain(int calnow, int calnone) {
    /* คำนนวณเป็นเปอร์เซ็นง่ายๆ สมมุติ Kcalปัจจุบันคือ 800 ถ้าเลือกไม่ออกกำลังกายเลย Kcalจะเท่ากับ 1792
     800/1792=0.4464285714285714 เปอร์เซ็น
    */
    double cirper = calnow / calnone;
    if (cirper > 1) {
      setState(() {
        circlePercent = 1.0; // ต้องไปจัดการว่าค่าแคลลอรี่ที่เหลือจะเอายังไง circlePercent = cirper - 1.0;
      });
    } else {
      setState(() {
        circlePercent = cirper;
      });
    }
  }

  void getCals(double wei, int hei, int age,String gender) {
    // https://www.lokehoon.com/app.php?q_id=calculate_bmr_tdee
    // https://www.calculator.net/bmr-calculator.html
    // สูตรคำนวณแคลเลอรี่อยู่ในลลิ้งด้านบน
    late int cal;

    if(gender=="ชาย"){
      //cal = (66 + (13.7 * wei) + (5 * hei) - (4.7 * age)).round(); 
      cal = (10 * wei + 6.25 * hei - 5 * age + 5).round();
    } else {
      //cal = (655 + (9.6 * wei) + (1.8 * hei) - (4.7 * age)).round();
      cal = (10 * wei + 6.25 * hei - 5 * age - 161).round();
    }
    
    setState(() {
      cals = cal;
      calNone = (cals * 1.2).round(); // ไม่ออกกำกายเลย
      cal_1to3day = (cals * 1.375).round(); // ออก 1-3 วัน
      cal_4to5day = (cals * 1.55).round(); // ออก 4-5 วัน
      cal_6to7day = (cals * 1.7).round(); // ออก 6-7 วัน
      cal_2perday = (cals * 1.9).round(); // ออก 2 ครั้งต่อวัน
      selecCals = calNone; // ใช้ selecCals มาแทน cals เพราะจะได้แทนตัวแปรที่เลือกตอนติ้กถูก แทนแคลลอรี่ที่เลือก ณ ขณะนี้

      // https://www.womenshealthmag.com/uk/food/weight-loss/a706111/counting-calculate-macros/#:~:text=To%20work%20out%20how%20many%20grams%20of%20each%20you%20need,grams%20of%20each%20to%20eat.
      // ส่วนคำนวณโปรตีน คาร์โบไฮเดรต ไขมันที่ผู้ใช้ต้องการต่อวัน
      carb = ((cals * 0.3) / 4).round(); // คำนวณคาร์โบไฮเดตรโดยคิดเป็น 30% ในวันนี้
      pro = ((cals * 0.4) / 4).round(); // คำนวณโปรตีนโดยคิดเป็น 40% ในวันนี้
      fat = ((cals * 0.3) / 9).round(); // คำนวณไขมันโดยคิดเป็น 30% ในวันนี้
    });
  }

  // ฟังก์ชั่นแก้ไขการเรียก async กับ await ในฟังก์ชั่น initState() ไม่ได้ 
  void asyncMethod() async {
    /* เลือกฐานข้อมูลของอาหารที่ใส่ในหน้า addfoods มาบวกกันแล้วแสดงแคลลอรี่ปัจจุบันของเรา
     อยู่ในไฟล์ food_provider.dart กับฟังก์ชั่นจัดการฐานข้อมูลดึงข้อมูลอาหารมาบวกกันอยู่ในไฟล์ food_db.dart
    */
    List values = [];
    var provider = Provider.of<FoodProvider>(context, listen: false);
    values = await provider.loadCals("user_foods.db"); // ส่งค่าข้อมูลมาเป็น List แยกค่า cals กับ protein ออกจากกัน
    setState(() {
      calsNow = values[0]; // แคลลอรี่ตอนนี้ในฐานข้อมูล "user_foods.db"
      userPro = values[1]; // โปรตีนตอนนี้ในฐานข้อมูล "user_foods.db"
      calRemain(calsNow, selecCals);
    });
  }

  Future<void> _getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    asyncMethod();

    // .exists เป็นฟังก์ชั้นตรวจสอบว่าข้อมูลมีไหม
    if(doc.exists) {
      setState(() {
        name = doc["name"].toString();
        weight = double.parse(doc["weight"].toString());
        height = int.parse(doc["height"].toString());
        age = int.parse(doc["age"].toString());
        gender = doc["gender"].toString();
        if(gender == "ชาย"){
          _genderSelected1 = true;
          _genderSelected2 = false;
        } else {
          _genderSelected1 = false;
          _genderSelected2 = true;
        }
        getCals(weight, height, age, gender);
      });
    } else {
      setState(() {
        name = "null";
        weight = 0.0;
        height = 0;
        age = 0;
        gender = "null";
        getCals(0, 0, 0, "");
      });
    }
  }

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
  }

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ

    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'นับแคลลอรี่',
                  style: h1,
                ),
              ),
              box, // ตัวแปร SizedBox ที่ตั้งไว้
              Card(
                elevation: 5,
                color: Colors.grey,
                shape: const StadiumBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  title: Text(name, style: h1,), // ไว้ใส่ชื่อละกัน
                  subtitle: Row( // ไว้ใส่น้ำหนัก ส่วนสูง อายุ เพศ
                    children: [
                      Column(
                        children: [
                          Text(weight.toString() + " Kg", style: content1,),
                          Text(height.toString() + " Cm", style: content1,),
                        ],
                      ),
                      box, // ตัวแปร SizedBox ที่ตั้งไว้
                      Column(
                        children: [
                          Text(age.toString() + " ปี", style: content1,),
                          Text(gender, style: content1,),
                        ],
                      ),
                      const SizedBox(width: 100,),
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.indigoAccent,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.create_rounded),
                          onPressed: () async {
                              // pop-up ที่แสดงขึ้นมาให้แก้ไขข้อมูลได้ โดยใช้ showDialog
                              /* ในปัญหาของการที่ TextFormField แก้ไขพร้อมกันไม่ได้กับมีข้อความแสดงแต่แรก เราต้อง
                                 ใส่ค่าใน TextEditingController ตั้งแต่แรกเลยแล้วค่อยไปใส่ใน TextFormField
                              */
                              TextEditingController nameController = TextEditingController(text: name);
                              TextEditingController weightController = TextEditingController(text: weight.toString());
                              TextEditingController heightController = TextEditingController(text: height.toString());
                              TextEditingController ageController = TextEditingController(text: age.toString());
                              await showDialog<String>( 
                                /* ตอนที่เลือกเพศมันมีปัญหากับ showDialog ตรงที่ว่ามันไม่ยอมขึ้น seleted สีฟ้า
                                   เราได้แก้ปัญหาโดยใช้ StreamBuilder ในการเช็คว่ามีการส่ง stream มาไหม
                                   จะได้เปลี่ยนแปลง UI 
                                   -- https://stackoverflow.com/questions/53123244/change-alertdialog-title-dynamically-showdialog
                                */
                                context: context,
                                builder: (context) {
                                  StreamController<String> controller = StreamController<String>.broadcast();
                                  return AlertDialog(
                                    title: const Text('แก้ไขข้อมูล'),
                                    content: StreamBuilder(
                                      stream: controller.stream,
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                                        return Form(
                                          key: keyForm,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  autocorrect: true,
                                                  keyboardType: TextInputType.name,
                                                  controller: nameController,
                                                  validator: RequiredValidator(errorText: 'กรุณาป้อนชื่อ'),
                                                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                  decoration: InputDecoration(
                                                    border: border,
                                                    labelText: 'ชื่อ',
                                                  ),
                                                ),
                                                box,
                                                TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: weightController,
                                                  validator: MultiValidator([
                                                    RequiredValidator(errorText: 'กรุณาป้อนน้ำหนัก'),
                                                    RangeValidator(min: 20, max: 1000, errorText: 'น้ำหนักเกินช่วง'),
                                                  ]),
                                                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                  decoration: InputDecoration(
                                                    border: border,
                                                    labelText: 'น้ำหนัก',
                                                  ),
                                                ),
                                                box,
                                                TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: heightController,
                                                  validator: MultiValidator([
                                                    RequiredValidator(errorText: 'กรุณาป้อนความสูง'),
                                                    RangeValidator(min: 59, max: 300, errorText: 'ความสูงเกินช่วง'),
                                                  ]),
                                                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                  decoration: InputDecoration(
                                                    border: border,
                                                    labelText: 'ความสูง',
                                                  ),
                                                ),
                                                box,
                                                TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: ageController,
                                                  validator: MultiValidator([
                                                    RequiredValidator(errorText: 'กรุณาป้อนอายุ'),
                                                    RangeValidator(min: 6, max: 100, errorText: 'อายุเกินช่วง'),
                                                  ]),
                                                  // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                                                  decoration: InputDecoration(
                                                    border: border,
                                                    labelText: 'อายุ',
                                                  ),
                                                ),
                                                box,
                                                // ตังเลือกแบบเป็นกล่อง ChoiceChip
                                                Row(
                                                  children: [
                                                    ChoiceChip(
                                                      label: const Text('ชาย'), 
                                                      selected: _genderSelected1, 
                                                      onSelected: (value){
                                                        setState(() {
                                                          _genderSelected1 = value;
                                                          _genderSelected2 = false;
                                                          gender = "ชาย";
                                                          controller.add("ชาย");
                                                        });
                                                      },
                                                      labelStyle: snapshot.data.toString()=="ชาย"||gender=="ชาย"? whiteTxt : blueTxt,
                                                      selectedColor: snapshot.data.toString()=="ชาย"||gender=="ชาย"? Colors.blue : Colors.white,
                                                      avatarBorder: circleBorder,
                                                    ),
                                                    box,
                                                    ChoiceChip(
                                                      label: const Text('หญิง'), 
                                                      selected: _genderSelected2, 
                                                      onSelected: (value){
                                                        setState(() {
                                                          _genderSelected1 = false;
                                                          _genderSelected2 = value;
                                                          gender = "หญิง";
                                                          controller.add("หญิง");
                                                        });
                                                      },
                                                      labelStyle: snapshot.data.toString()=="หญิง"||gender=="หญิง"? whiteTxt : blueTxt,
                                                      selectedColor: snapshot.data.toString()=="หญิง"||gender=="หญิง"? Colors.blue : Colors.white,
                                                      avatarBorder: circleBorder,
                                                    ),
                                                  ],
                                                ),
                                                box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    ),
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () async { 
                                          if(keyForm.currentState!.validate()){
                                            // อัพเดตข้อมูลส่วนตัวบน firebase
                                            // https://firebase.flutter.dev/docs/firestore/usage/
                                            _userCollection.doc(user.currentUser!.uid).update({
                                              'name':nameController.text,
                                              'weight':weightController.text,
                                              'height':heightController.text,
                                              'age':ageController.text,
                                              'gender':gender
                                            }).then((value) {
                                              getAppBackgroundColor();
                                                // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
                                                Fluttertoast.showToast(
                                                  msg: 'ข้อมูลอัพเดตแล้ว',
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
                                                    builder: (context) => MainScreen(const Text("แคลลอรี่"), const ShowCalScreen(), 1, backgroundColor)
                                                  ), // this mainpage is your page to refresh
                                                  (Route<dynamic> route) => false,
                                                );
                                              }
                                            ).catchError((error) {
                                              // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
                                              Fluttertoast.showToast(
                                                msg: error,
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                            });
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
                      ),
                    ],
                  ), 
                ),
              ),
              box, // ตัวแปร SizedBox ที่ตั้งไว้ 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'ต้องการ',
                        style: h2,
                      ),
                      Text(
                        (selecCals).toString() + ' Kcal',
                        style: h1,
                      ),
                      box, // ตัวแปร SizedBox ที่ตั้งไว้
                      Text(
                        'กินแล้ว',
                        style: h2,
                      ),
                      Text(
                        (calsNow).toString() + ' Kcal',
                        style: h1,
                      ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10,
                    animation: true,
                    arcType: ArcType.FULL,
                    percent: circlePercent,
                    arcBackgroundColor: Colors.grey.withOpacity(0.3),
                    startAngle: 60,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.cyan[600],
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (selecCals - calsNow < 0 ? 0 : selecCals - calsNow).toString(),
                          style: const TextStyle(fontSize: 30, color: Colors.black,),
                        ),
                        Text('เหลืออีก Kcal', style: h2,),
                      ],
                    ),
                  ),
                ],
              ),
              box, // ตัวแปร SizedBox ที่ตั้งไว้

              // ใช้ ListTile ในการแสดงผลแบบรายชื่อแล้วใส่ใน leading เป็น Radio<SingingCharacter>
              // เพื่อทำตัวเลือกแบบติ้กถูกแล้วอัพเดตค่าแคลลอรี่ที่แสดงผลบนจอ
              ListTile(
                title: Text(
                  'ไม่ออกกำลังกาย ' + (calNone).toString() + ' Kcal',
                  style: content1,
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t1,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      selecCals = calNone;
                      calRemain(calsNow, selecCals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 1-3 วัน ' + (cal_1to3day).toString() + ' Kcal',
                  style: content1,
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t2,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      selecCals = cal_1to3day;
                      calRemain(calsNow, selecCals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 4-5 วัน ' + (cal_4to5day).toString() + ' Kcal',
                  style: content1,
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t3,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      selecCals = cal_4to5day;
                      calRemain(calsNow, selecCals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 6-7 วัน ' + (cal_6to7day).toString() + ' Kcal',
                  style: content1,
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t4,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      selecCals = cal_6to7day;
                      calRemain(calsNow, selecCals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 2 ครั้งต่อวัน ' + (cal_2perday).toString() + ' Kcal',
                  style: content1,
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t5,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      selecCals = cal_2perday;
                      calRemain(calsNow, selecCals);
                    });
                  },
                ),
              ),
              box, // ตัวแปร SizedBox ที่ตั้งไว้
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            child: Image.asset('assets/fat.jpg'),
                            borderRadius: borderCircle,
                          ),
                          radius: 40,
                        ),
                        Text('ไขมัน: ' + fat.toString() + ' กรัม ', style: content2,),
                      ],
                    ),
                    box, // ตัวแปร SizedBox ที่ตั้งไว้
                    Column(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            child: Image.asset('assets/protein.jpg'),
                            borderRadius: borderCircle,
                          ),
                          radius: 40,
                        ),
                        Text('โปรตีน: ' + userPro.toString() + '/' + pro.toString() + ' กรัม ',style: content2),
                      ],
                    ),
                    box, // ตัวแปร SizedBox ที่ตั้งไว้
                    Column(
                      children: [
                        CircleAvatar(
                          child: ClipRRect(
                            child: Image.asset('assets/carb.jpg'),
                            borderRadius: borderCircle,
                          ),
                          radius: 40,
                        ),
                        Text('คาร์โบไฮเดตร: ' + carb.toString() + ' กรัม ', style: content2),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}