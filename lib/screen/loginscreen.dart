import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/registerscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SizedBox box = const SizedBox(height: 20,);
  OutlineInputBorder border = const OutlineInputBorder();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  late Color backgroundColor;
  // เช็คติ้กถูกการล็อคอิน
  bool _checkbox = false;
  // สีของตัวหนังสือในหน้านี้
  Color textcolor = Colors.white;
  // สีของตัวหนังสือตรงติ้กถูก
  Color checkTextColor = Colors.black;
  // FormFild text size
  double formfildTextSize = 15.0;
  // FormFild text color
  Color? formfildTextColor = Colors.grey[700];
  // ขนาดตัวหนังสือ
  double textSize = 16.0;

  // ฟังก์ชั่นในการประกาศข้อมูลที่มาจากฐานข้อมูลเพื่อเตรียมแสดงผลโดยใช้ TransactionProvider
  @override
  void initState(){
    super.initState();
    getAppBackgroundColor();
    Provider.of<FoodProvider>(context, listen: false).initData("foods.db");
  }

  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(title: Text('เกิดข้อผิดพลาด', style: TextStyle(fontSize: textSize, color: textcolor,),)),
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
            appBar: AppBar(title: Text('หน้าเข้าสู่ระบบ', style: TextStyle(fontSize: textSize, color: textcolor,),), backgroundColor: backgroundColor,),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("assets/user_icon.png"),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                          EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        ]),
                        decoration: InputDecoration(
                          border: border,
                          labelText: 'อีเมล',
                          labelStyle: TextStyle(fontSize: formfildTextSize, color: formfildTextColor,),
                        ),
                      ),
                      box,
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passwordController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                          MinLengthValidator(6, errorText: 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว'),  
                          PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'รหัสผ่านต้องประกอบด้วยตัวอักษรพอเศษอย่างน้อย 2 ตัว'),
                        ]),
                        decoration: InputDecoration(
                          border: border,
                          labelText: 'รหัสผ่าน',
                          labelStyle: TextStyle(fontSize: formfildTextSize, color: formfildTextColor,),
                        ),
                      ),
                      box,
                        Row(
                        children: [
                          Checkbox(
                            value: _checkbox, 
                            onChanged: (value) {
                              setState(() {
                                _checkbox = value!;
                              });
                            }
                          ),
                          Text('ลงชื่อค้างไว้', style: TextStyle(fontSize: textSize, color: checkTextColor,),)
                        ],
                      ),
                      box,
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                          onPressed: () async {
                            if(formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              // เรียกค่าอีเมลและรหัสที่เก็บในคอนทรอลเลอร์
                              var email = emailController.text;
                              var password = passwordController.text;
                            
                              // ขึ้นหน้าโหลดง่ายๆ
                              showDialog(
                                context: context, 
                                // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                                barrierDismissible: false,
                                builder: (context) {
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                              );

                              // เก็บค่าอีเมลที่ล็อคอิน
                              final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
                            
                              try {
                                // การเข้าล็อคอินใช้ FirebaseAuth ล็อคอินแบบใช้อีเมลและรหัสผ่าน
                                // เมื่อเข้าสู่ระบบสำเร็จจะแสดงข้อความ "เข้าสู่ระบบสำเร็จ" ผ่าน Fluttertoast แล้วเข้าสู่หน้าหลัก MainPage
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
                                Fluttertoast.showToast(
                                  msg: "เข้าสู่ระบบสำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                                );
                                sharedpreferences.setString('email', email);
                                sharedpreferences.setBool('isLogin', _checkbox);
                                // เอาหน้าโหลดออก
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) {
                                      return MainScreen(const Text("หน้าหลัก"), MainPage(backgroundColor), 0, backgroundColor);
                                    },
                                  )
                                );
                                });
                              } on FirebaseAuthException catch(e) {
                                // เอาหน้าโหลดออก
                                Navigator.of(context).pop();
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
                          }, 
                          child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: textSize, color: textcolor,),),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                          onPressed: () {
                            // ต้องแก้ส่วนนี้ตอนล็อกอินว่าจะต้องเช็คบัญชีผู้ใช้
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (context) {
                                  return const RegisterScreen();  
                                },
                              )
                            );
                          }, 
                          child: Text('สร้างบัญชีใหม่', style: TextStyle(fontSize: textSize, color: textcolor,),),
                        ),
                      ), 
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('หน้าสมัครบัญชี', style: TextStyle(fontSize: textSize, color: textcolor,),),),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}