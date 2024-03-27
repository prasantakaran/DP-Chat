import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final pk = GlobalKey<FormState>();
  final TextEditingController un = TextEditingController();
  final TextEditingController passw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Login"),
        titleTextStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 187, 32, 32),
            fontFamily: 'PangolinRegular'),
        backgroundColor: const Color.fromARGB(255, 255, 59, 157),
        leadingWidth: 300,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: Form(
            key: pk,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: un,
                  decoration: InputDecoration(
                      labelText: 'Enter your Email or phone number',
                      hintText: "Email or phone number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.black))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  controller: passw,
                  decoration: InputDecoration(
                      labelText: 'Enter User Password',
                      hintText: "Email Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (pk.currentState!.validate()) {
                      print("UserName: ${un.text},Password: ${passw.text}");
                    } else {
                      print("not validated");
                    }
                  },
                  child: const Text("Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
