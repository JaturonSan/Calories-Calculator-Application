/* หน้านี้เป็นหน้าแสดงแคลลอรี่ของคนๆนี้ */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

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
  int userPro = 0; // ตัวแปรโปรตีนที่ user ใส่เข้ามาในหน้าเพิ่มอาหาร
  int fat = 0; // ไขมันที่ usr ต้องการในแต่ละวัน
  double circlePercent = 0;
  SizedBox box = const SizedBox(width: 10, height: 10,);
  TextStyle h1 = const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,);
  TextStyle h2 = const TextStyle(fontSize: 15, color: Color(0xFF616161), fontWeight: FontWeight.bold);
  TextStyle content1 = const TextStyle(fontSize: 15, color: Colors.black);
  TextStyle content2 = const TextStyle(fontSize: 12, color: Colors.black);
  final user = FirebaseAuth.instance; // ข้อมูลของ user ปัจจุบัน
  

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
      cal = (10 * wei + 6.25 * hei - 5 * age + 5).round();
    } else {
      cal = (10 * wei + 6.25 * hei - 5 * age - 161).round();
    }
    
    setState(() {
      cals = cal;
      calNone = (cals * 1.2).round(); // ไม่ออกกำกายเลย
      cal_1to3day = (cals * 1.375).round(); // ออก 1-3 วัน
      cal_4to5day = (cals * 1.55).round(); // ออก 4-5 วัน
      cal_6to7day = (cals * 1.7).round(); // ออก 6-7 วัน
      cal_2perday = (cals * 1.9).round(); // ออก 2 ครั้งต่อวัน
    });
  }

  void getNutrients() {
    // https://www.womenshealthmag.com/uk/food/weight-loss/a706111/counting-calculate-macros/#:~:text=To%20work%20out%20how%20many%20grams%20of%20each%20you%20need,grams%20of%20each%20to%20eat.
    setState(() {
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

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ

    // คำสั่งในการหา user คนปัจจุบันแล้วนำข้อมูลมาแสดงบนแอป
    FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot snapshot) {
      for(var doc in snapshot.docs) {
        if(user.currentUser!.email.toString() == doc["email"]){
          name = doc["name"];
          weight = doc["weight"];
          height = doc["height"];
          age = doc["age"];
          gender = doc["gender"];
          asyncMethod();
          getCals(weight, height, age, gender);
          selecCals = calNone; // ใช้ selecCals มาแทน cals เพราะจะได้แทนตัวแปรที่เลือกตอนติ้กถูก แทนแคลลอรี่ที่เลือก ณ ขณะนี้
          getNutrients();
        }
      }
    });
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
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://img.lovepik.com/free-png/20210924/lovepik-cartoon-avocado-png-image_401366645_wh1200.png'),
                          radius: 40,
                        ),
                        Text('ไขมัน: ' + fat.toString() + ' กรัม ', style: content2,),
                      ],
                    ),
                    box, // ตัวแปร SizedBox ที่ตั้งไว้
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://www.clipartmax.com/png/middle/99-993803_cartoon-steak-background-beef-cartoon-meat-protein-cartoon-beef.png'),
                          radius: 40,
                        ),
                        Text('โปรตีน: ' + userPro.toString() + '/' + pro.toString() + ' กรัม ',style: content2),
                      ],
                    ),
                    box, // ตัวแปร SizedBox ที่ตั้งไว้
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://flyclipart.com/thumb2/carbohydrates-clipart-free-clip-art-images-197710.png'),
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