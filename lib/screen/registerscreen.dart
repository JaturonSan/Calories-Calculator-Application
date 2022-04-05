import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mini_project/model/profile.dart';
import 'package:mini_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({ Key? key }) : super(key: key);
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หน้าสมัครบัญชี'), backgroundColor: Colors.cyan[900],),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('ชื่อผู้ใช้'),
                TextFormField(
                  keyboardType: TextInputType.name,
                  onSaved: (name){
                    profile.username = name;
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนชื่อผู้ใช้'),
                    MinLengthValidator(4, errorText: 'ชื่อต้องมีความยาวอย่างน้อย 4 ตัว')
                  ]),
                ),
                const Text('รหัสผ่าน'),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  onSaved: (password){
                    profile.password = password;
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                    MinLengthValidator(8, errorText: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัว'),  
                    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'รหัสผ่านต้องประกอบด้วยตัวอักษรพอเศษอย่างน้อย 2 ตัว')
                  ]),
                ),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      var provider = Provider.of<ProfileProvider>(context, listen: false);
                      provider.addProfile(profile);
                      Navigator.pop(context);
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
}