
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ChattingController chatController = Get.find();
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    // backgroundColor: Colors.green,
                    backgroundImage: NetworkImage(
                        chatController.currentUser.value.userImage!),
                  ),
                ),
                const Text('Welcome! '),
                Obx(()=>Text('${chatController.currentUser.value.userName}', style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)),
              ],
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
                onPressed: (){chatController.googleSignIn.signOut();},
                child: const Text('Logout')),
          ],
        ));
  }
}
