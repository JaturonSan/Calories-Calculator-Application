import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/screen/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({ Key? key }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  bool _genderSelected1 = false; // ตัวแปรเช็คเพศชาย
  bool _genderSelected2 = false; // ตัวแปรเช็คเพศหญิง
  final passwordController = TextEditingController();
  final passwordchkController = TextEditingController();
  OutlineInputBorder border = const OutlineInputBorder(); // ขอบของ TextFormField
  final Future<FirebaseApp> firebase = Firebase.initializeApp(); // เกี่ยวกับการ login ฐานข้อมูลผู้ใช้ใน firebase 
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users'); // ฐานข้อมูล collection ชื่อ 'users'
  CircleBorder circleBorder = const CircleBorder(side: BorderSide(color: Colors.blue,width: 2,)); // ขอบของ ChoiceChip
  TextStyle whiteTxt = const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold); // ตัวหนังสือบน ChoiceChip
  TextStyle blueTxt = const TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold); // ตัวหนังสือบน ChoiceChip
  String gendertxt = ""; // เก็บเพศของผู้ใช้
  String pass = "";
  SizedBox box = const SizedBox(height: 20,width: 20,);
  Color backgroundColor = Colors.cyan[900]!;

  Future<dynamic> addUser(String email,String name,double weight,int height,int age,String gender) async {
    return 
    // นำข้อมูลชื่อผู้ใช้ email น้ำหนัก ส่วนสูง อายุ เพศใส่ลงในฐานข้อมูล firebase โดยใช้ userid
    await _userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      "email": email, 
      "name": name,
      "weight": weight,
      "height": height,
      "age": age,
      "gender": gender 
    });
  }

  @override
  void initState(){
    super.initState();
    getAppBackgroundColor();
  }

  // เรียกสีแอปหลักจาก SharedPreferences
  void getAppBackgroundColor() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      backgroundColor = Color(int.parse(sharedpreferences.getString('AppBackgroundColor')!, radix: 16,));
    });
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
            appBar: AppBar(title: const Text('หน้าสมัครบัญชี'), backgroundColor: backgroundColor,),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                          EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        ]),
                        // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                        decoration: InputDecoration(
                          border: border,
                          labelText: 'อีเมล',
                        ),
                      ),
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
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
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passwordController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                          MinLengthValidator(6, errorText: 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว'),  
                          PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'รหัสผ่านต้องประกอบด้วยตัวอักษรพอเศษอย่างน้อย 2 ตัว'),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            pass = value;
                          });
                        },
                        // onSaved: (value) {
                        //   setState(() {
                        //     pass = value!;
                        //   });
                        // },
                        // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                        decoration: InputDecoration(
                          border: border,
                          labelText: 'ป้อนรหัส',
                        ),
                      ),
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passwordchkController,
                        validator: (val) => MatchValidator(errorText: 'รหัสผ่านไม่ตรงกัน').validateMatch(val!, pass),
                        // แก้ไขการแสดงผลนิดหน่อยให้มีกรอบ border แล้วมี text อยู่ข้างใน
                        decoration: InputDecoration(
                          border: border,
                          labelText: 'ป้อนรหัสอีกครั้ง',
                        ),
                      ),
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
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
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
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
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
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
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
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
                                gendertxt = "ชาย";
                              });
                            },
                            labelStyle: _genderSelected1? whiteTxt : blueTxt,
                            selectedColor: _genderSelected1? Colors.blue : Colors.white,
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
                                gendertxt = "หญิง";
                              });
                            },
                            labelStyle: _genderSelected2? whiteTxt : blueTxt,
                            selectedColor: _genderSelected2? Colors.blue : Colors.white,
                            avatarBorder: circleBorder,
                          ),
                        ],
                      ),
                      box, // กล่อง SizedBox ขนาดความสูง 20 พิกเซล
                      SizedBox(
                        height: 30,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if(formKey.currentState!.validate() && gendertxt!=""){

                              // ขึ้นหน้าโหลดง่ายๆ
                              showDialog(
                                context: context, 
                                // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                                barrierDismissible: false,
                                builder: (context) {
                                  return const Center(child: CircularProgressIndicator(),);
                                }
                              );

                              try {
                                FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: pass).then((value) {
                                    addUser(emailController.text,nameController.text,double.parse(weightController.text),int.parse(heightController.text),int.parse(ageController.text),gendertxt);
                                    
                                    // ใช้ Fluttertoast ในการแสดงผลแทน showDialog
                                    Fluttertoast.showToast(
                                      msg: "สมัครสำเร็จ",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                    );
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (context) => const LoginScreen()
                                    ));
                                  }
                                );
                                // เอาหน้าโหลดออก
                                Navigator.of(context).pop();
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
                            }
                          }, 
                          child: const Text('ลงทะเบียน')
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