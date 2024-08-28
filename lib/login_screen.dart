import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/firebase_authentication_app.dart';
import 'package:firebase_sample/firebase_db_manager.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: emailTextEditingController,
              focusNode: emailFocusNode,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(passwordFocusNode),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  hintText: "Email Address",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepPurple)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepPurple))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordTextEditingController,
              focusNode: passwordFocusNode,
              textInputAction: TextInputAction.go,
              onSubmitted: (val) async {
                if (val.length >= 8 &&
                    validatingEmail(emailTextEditingController.value.text)) {
                  final user = await FirebaseAuthenticationApp.createAccount(
                      emailTextEditingController.value.text, val);
                  if (user != null) {
                    FirebaseDBManager.add(user.user!.email!);
                  }
                } else {
                  debugPrint("Not Valid Data");
                }
              },
              obscureText: isObscure,
              decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    child: Icon(isObscure
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye_rounded),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepPurple)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.deepPurple))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if (passwordTextEditingController.value.text.length >= 8 &&
                      validatingEmail(emailTextEditingController.value.text)) {
                    final user = await FirebaseAuthenticationApp.createAccount(
                        emailTextEditingController.value.text,
                        passwordTextEditingController.value.text);
                    if (user != null) {
                      FirebaseDBManager.add(user.user!.email!);
                    }
                  } else {
                    debugPrint("Not Valid Data");
                  }
                },
                child: const Text("Sign Up")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  FirebaseDBManager.delete(
                      FirebaseAuth.instance.currentUser!.email!);
                  FirebaseAuth.instance.currentUser!.delete();
                },
                child: const Text("Delete My Acc")),
            const SizedBox(height: 40),
            Center(
              child: Row(
                children: [
                  VerticalDivider(
                    color: Colors.purple,
                    thickness: 2,
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                  const Text("OR"),
                  VerticalDivider(
                    color: Colors.purple,
                    thickness: 2,
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                  onPressed: () async {
                    // final user =
                    //     await FirebaseAuthenticationApp.signInWithGoogle();
                    // if (user.user != null) {
                    //   debugPrint(user.user!.email);
                    // } else {
                    //   debugPrint("authentication with google failed");
                    // }
                    FirebaseDBManager.update(FirebaseAuth.instance.currentUser!.email!);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login with",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.deepPurple,
                        size: 48,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  bool validatingEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }
}
