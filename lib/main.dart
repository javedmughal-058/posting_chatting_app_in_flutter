
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';
import 'views/signUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ChattingController socialMediaController = Get.put(ChattingController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Media',
      theme: ThemeData(
        primaryColor: const Color(0xFF1a2f45),
      ),
      home: const SignUp(),
    );
  }
}