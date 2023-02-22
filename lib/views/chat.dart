
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';
import 'conversation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChattingController chatController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.getUsers();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Chat Screen')),
      body: Obx(()=> chatController.userList.isEmpty ? const LinearProgressIndicator() : ListView.builder(
        padding: const EdgeInsets.all(8),
          itemCount: chatController.userList.length,
          itemBuilder: (context, index) {
          final userData = chatController.userList[index];
        return GestureDetector(
          onTap: (){
            chatController.showChat(chatController.userId.value, userData['user_id'], userData['image_url']).then((_) {
              chatController.startChatting('${chatController.userId.value}+${userData['user_id']}').then((_) {
                Get.to(()=>const ConversationScreen(), arguments: {"senderImage": userData['image_url'],"senderName" : userData['display_name']});
              });

            });
          },
          child: Card(
            margin: const EdgeInsets.only(top: 10),
            shadowColor: Theme.of(context).primaryColor.withOpacity(0.003),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(userData['image_url']),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      Text(userData['display_name'], style: const TextStyle(color: Colors.black, fontSize: 13),),
                      Text('Followers ${userData['user_followers']}', style: const TextStyle(color: Colors.black, fontSize: 13),),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      })),
    );
  }
}
