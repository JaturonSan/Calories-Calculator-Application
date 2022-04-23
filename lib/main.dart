import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/providers/food_provider.dart';
import 'package:mini_project/screen/mainscreen.dart';
import 'package:mini_project/screen/registerscreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return FoodProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.blue),
        home: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late String username;
  late String userpass;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SizedBox box = const SizedBox(height: 20,);
  OutlineInputBorder border = const OutlineInputBorder();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // ฟังก์ชั่นในการประกาศข้อมูลที่มาจากฐานข้อมูลเพื่อเตรียมแสดงผลโดยใช้ TransactionProvider
  @override
  void initState(){
    super.initState();
    Provider.of<FoodProvider>(context, listen: false).initData("foods.db");
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(title: const Text('error')),
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
            appBar: AppBar(title: const Text('หน้าเข้าสู่ระบบ'), backgroundColor: Colors.cyan[900],),
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
                          labelStyle: const TextStyle(fontSize: 15,),
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
                          labelStyle: const TextStyle(fontSize: 15,),
                        ),
                      ),
                      box,
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                          onPressed: () async {
                            var email = emailController.text;
                            var password = passwordController.text;
                            
                            try {
                              // การเข้าล็อคอินใช้ FirebaseAuth ล็อคอินแบบใช้อีเมลและรหัสผ่าน
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
                              // เมื่อเข้าสู่ระบบสำเร็จจะแสดงข้อความ "เข้าสู่ระบบสำเร็จ" ผ่าน Fluttertoast แล้วเข้าสู่หน้าหลัก MainPage
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return MainScreen(const Text("หน้าหลัก"), MainPage(), 0);
                                  },
                                )
                              );
                              });
                            } on FirebaseAuthException catch(e) {
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
                          }, 
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.cyan[900]),
                          onPressed: () {
                            // ต้องแก้ส่วนนี้ตอนล็อกอินว่าจะต้องเช็คบัญชีผู้ใช้
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                                return RegisterScreen();  
                              },)
                            );
                          }, 
                          child: const Text('สร้างบัญชีใหม่'),
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
          appBar: AppBar(title: const Text('หน้าสมัครบัญชี'),),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}