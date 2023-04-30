import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SizedBox box = const SizedBox(height: 20,);
  Color backgroundColor = Colors.cyan[900]!;
  // สีของหัวข้อความและข้อความเนื้อหา
  Color textColor = Colors.black;
  // ขนาดหัวข้อความ
  double headTextSize = 16.0;
  // ขนาดของข้อความเนื้อหา
  double contentTextSize = 14.0;
  Divider line = const Divider();

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
    });
  }

  @override
  void initState() {
    super.initState();
    getAppBackgroundColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าการตั้งค่า'), backgroundColor: backgroundColor,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  height: 10,
                  width: 10,
                  color: backgroundColor,
                ),
                title: Text('สีเมนูแอป', style: TextStyle(color: textColor, fontSize: headTextSize,),),
                subtitle: Text('เปลี่ยนสีของเมนูแอป', style: TextStyle(color: textColor, fontSize: contentTextSize,),),
                onTap: () {
                  Color color = backgroundColor;
                  showDialog(
                    context: context, 
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text('กรุณาเลือกสี', style: TextStyle(color: textColor, fontSize: contentTextSize,),),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ตัวเลือกสีโดยใช้แพ็กเกตชื่อ flutter_colorpicker
                          ColorPicker(
                            enableAlpha: false,
                            labelTypes: const [],
                            pickerColor: color, 
                            onColorChanged: (Color selectcolor) => setState(() {color = selectcolor;}),
                          )
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
                            setState(() {
                              backgroundColor = color;
                              sharedpreferences.setString('AppBackgroundColor', color.value.toRadixString(16));
                            });
                            Navigator.pop(context);
                          },
                          child: Text('เลือกสี', style: TextStyle(fontSize: headTextSize, color: textColor,),),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ยกเลิก', style: TextStyle(fontSize: headTextSize, color: textColor,),),
                        ),
                      ],
                    ),
                  );
                },
              ),
              line,
            ],
          ),
        ),
      ),
    );
  }
}