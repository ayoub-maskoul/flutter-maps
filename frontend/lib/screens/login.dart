

import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/services/api_response.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }
    else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              decoration: InputDecoration(labelText: 'Entre email'),
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Entre password'),
              validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
            ),
            SizedBox(height: 10,),
            loading? Center(child: CircularProgressIndicator(),)
            :
            TextButton(child: Text("Login"), onPressed: () { 
                 if (formkey.currentState!.validate()){
                  setState(() {
                    loading = true;
                    _loginUser();
                  });
                }
             },
            ),
            SizedBox(height: 10,),
            TextButton(child: Text("Dont have an acount?"), onPressed: () { 
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Register()), (route) => false);
             },
            ),
          ],
        ),
      )
    );
  }
}