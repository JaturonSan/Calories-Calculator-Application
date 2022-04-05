/* หน้านี้เป็นหน้าแสดงแคลลอรี่ของคนๆนี้ */

import 'package:flutter/material.dart';
import 'package:mini_project/screen/sidemenu.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ShowCalScreen extends StatefulWidget {
  const ShowCalScreen({Key? key}) : super(key: key);

  @override
  State<ShowCalScreen> createState() => _ShowCalScreenState();
}

// ตัวแปรสำหรับตัวเลือกติ้กวงกลม
enum SingingCharacter { t1, t2, t3, t4, t5 }

class _ShowCalScreenState extends State<ShowCalScreen> {
  double weight = 55.4;
  int height = 167;
  int age = 22;
  int calsNow =
      1800; // Kcalลอรี่ที่เหลือในวันนี้ ต้องมาจากหน้าเพิ่มอาหารในฐานข้อมูล
  int cals = 0; // Kcalเลอรี่ BMR
  int calNone = 0; // ไม่ออกกำลังกายเลย
  int cal_1to3day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 1-3 วันต่อสัปดาห์
  int cal_4to5day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 4-5 วันต่อสัปดาห์
  int cal_6to7day = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 6-7 วันต่อสัปดาห์
  int cal_2perday = 0; // Kcalเลอรี่รวมถ้าเราออกกำลังกาย 2 ครั้งต่อวัน
  int carb = 0; // คาร์โบไฮเดรต
  int pro = 0; // โปรตีน
  int fat = 0; // ไขมัน
  double circlePercent = 0;

  // ตัวแปรสำหรับตัวเลือกติ้กวงกลม
  late SingingCharacter? _character = SingingCharacter.t1;

  // initSate เป็นฟังก์ชั่นในการเริ่มฟังก์ชั่นต่างๆก่อนสร้างหน้าขึ้น เพื่อเตียมข้อมูลที่จะแสดงผลไว้ก่อน เพื่อไม่ให้เกิดค่าว่าง หรือหน้าไม่ยอมโหลด
  @override
  void initState() {
    super.initState(); // ใช้คำสั่ง super.initState(); เพื่อเตรียมฟังก์ชั่น init แล้วเรียกฟังก์ชั่นที่ต้องการ
    getCals(weight, height, age);
    getNutrients();
    calRemain(calsNow, cals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
          title: const Text('หน้าแสดงแคลลอรี่'),
          backgroundColor: Colors.cyan[900]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'นับแคลลอรี่',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                weight.toString() +
                    ' kg ' +
                    age.toString() +
                    ' ปี  ' +
                    height.toString() +
                    ' cm', // แสดงอายุกับส่วนสูง, // แสดงน้ำหนัก
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'ต้องการ',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (cals).toString() + ' Kcal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'กินแล้ว',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (calsNow).toString() + ' Kcal',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          (cals - calsNow < 0 ? 0 : cals - calsNow)
                              .toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                        Text('เหลืออีก Kcal')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              // ใช้ ListTile ในการแสดงผลแบบรายชื่อแล้วใส่ใน leading เป็น Radio<SingingCharacter>
              // เพื่อทำตัวเลือกแบบติ้กถูกแล้วอัพเดตค่าแคลลอรี่ที่แสดงผลบนจอ
              ListTile(
                title: Text(
                  'ไม่ออกกำลังกาย ' + (calNone).toString() + ' Kcal',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t1,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      cals = calNone;
                      calRemain(calsNow, cals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 1-3 วัน ' + (cal_1to3day).toString() + ' Kcal',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t2,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      cals = cal_1to3day;
                      calRemain(calsNow, cals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 4-5 วัน ' + (cal_4to5day).toString() + ' Kcal',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t3,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      cals = cal_4to5day;
                      calRemain(calsNow, cals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 6-7 วัน ' + (cal_6to7day).toString() + ' Kcal',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t4,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      cals = cal_6to7day;
                      calRemain(calsNow, cals);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'ออกกำลังกาย 2 ครั้งต่อวัน ' + (cal_2perday).toString() + ' Kcal',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.t5,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      cals = cal_2perday;
                      calRemain(calsNow, cals);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://img.lovepik.com/free-png/20210924/lovepik-cartoon-avocado-png-image_401366645_wh1200.png'),
                          backgroundColor: Colors.green,
                          radius: 40,
                        ),
                        Text(
                          'ไขมัน: ' + fat.toString() + ' กรัม ',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.clipartmax.com/png/middle/99-993803_cartoon-steak-background-beef-cartoon-meat-protein-cartoon-beef.png'),
                          backgroundColor: Colors.redAccent,
                          radius: 40,
                        ),
                        Text('โปรตีน: ' + pro.toString() + ' กรัม ',
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://flyclipart.com/thumb2/carbohydrates-clipart-free-clip-art-images-197710.png'),
                          backgroundColor: Colors.brown,
                          radius: 40,
                        ),
                        Text('คาร์โบไฮเดตร: ' + carb.toString() + ' กรัม ',
                            style: const TextStyle(fontSize: 13)),
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

  void calRemain(int calnow, int calnone) {
    /* คำนนวณเป็นเปอร์เซ็นง่ายๆ สมมุติ Kcalปัจจุบันคือ 800 ถ้าเลือกไม่ออกกำลังกายเลย Kcalจะเท่ากับ 1792
     800/1792=0.4464285714285714 เปอร์เซ็น
    */
    double cirper = calnow / calnone;
    if (cirper > 1) {
      setState(() {
        circlePercent =
            1.0; // ต้องไปจัดการว่าค่าแคลลอรี่ที่เหลือจะเอายังไง circlePercent = cirper - 1.0;
      });
    } else {
      setState(() {
        circlePercent = cirper;
      });
    }
  }

  void getCals(double wei, int hei, int age) {
    // https://www.lokehoon.com/app.php?q_id=calculate_bmr_tdee
    // https://www.calculator.net/bmr-calculator.html
    // สูตรคำนวณแคลเลอรี่อยู่ในลลิ้งด้านบน
    int cal = (10 * wei + 6.25 * hei - 5 * age + 5).round();
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
      carb = ((cals * 0.3) / 4)
          .round(); // คำนวณคาร์โบไฮเดตรโดยคิดเป็น 30% ในวันนี้
      pro = ((cals * 0.4) / 4).round(); // คำนวณโปรตีนโดยคิดเป็น 40% ในวันนี้
      fat = ((cals * 0.3) / 9).round(); // คำนวณไขมันโดยคิดเป็น 30% ในวันนี้
    });
  }
}
