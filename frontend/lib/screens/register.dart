
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/services/api_response.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController
    nameController = TextEditingController(), 
    emailController = TextEditingController(),
    passwordController = TextEditingController(),
    passwordConfirmController = TextEditingController();

  void _registerUser () async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
    if(response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } 
    else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }

  // Save and redirect to home
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
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Entre name'),
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Entre email'),
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Entre password'),
              validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              validator: (val) => val != passwordController.text ? 'Confirm password does not match' : null,
            ),
            SizedBox(height: 20,),
            loading ? 
              Center(child: CircularProgressIndicator())
            :TextButton(child: Text("Register"), onPressed: () { 
                 if(formKey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                    _registerUser();
                  });
                }
             },
            ),
            SizedBox(height: 20,),
            TextButton(child: Text("Already have an account?"), onPressed: () { 
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
             },
            ),
          ],
        ),
      ),
    );
  }
}