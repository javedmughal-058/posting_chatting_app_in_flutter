import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';

import '../custom/customTextField.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ChattingController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(),
          body: Container(
            width: Get.width,
            height: Get.height,
            // padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: chatController.conversationList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Row(
                                mainAxisAlignment: chatController
                                            .conversationList[index].messageID ==
                                    chatController.userId.value
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  chatController
                                      .conversationList[index].messageID !=
                                      chatController.userId.value
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          // child: const CircleAvatar(
                                          //   // backgroundColor: Colors.brown,
                                          //   backgroundImage: AssetImage(
                                          //       'assets/images/bot.png'),
                                          // ),
                                        )
                                      : const SizedBox(),
                                  chatController
                                      .conversationList[index].messageID ==
                                      chatController.userId.value
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Bubble(
                                            showNip: true,
                                            nip: BubbleNip.rightBottom,
                                            color: const Color.fromRGBO(
                                                195, 246, 202, 1.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Text(
                                                  chatController
                                                      .conversationList[index]
                                                      .message!,
                                                  maxLines: 3,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ),
                                            elevation: 0.0,
                                            radius: const Radius.circular(15),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Bubble(
                                            showNip: true,
                                            nip: BubbleNip.leftBottom,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            child:Text('${ chatController
                                                .conversationList[index].message}'),
                                            elevation: 0.0,
                                            radius: const Radius.circular(15),
                                          ),
                                        ),
                                  chatController
                                      .conversationList[index].messageID ==
                                      chatController.userId.value
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          // child: CircleAvatar(
                                          //   // backgroundColor: Colors.green,
                                          //   backgroundImage: NetworkImage(
                                          //       _userController
                                          //           .userImage.value),
                                          // ),
                                        )
                                      : const SizedBox()
                                ],
                              ));
                        })),
                const Divider(),
                Container(
                  child: ListTile(
                    dense: true,
                    title: CustomTextField(
                      borderColor: Theme.of(context).primaryColor,
                      controller: chatController.messageInputText,
                      textInputType: TextInputType.text,
                      isReadOnly:
                          // assistantStart? true :
                          false,
                      hint: 'write something here...',
                      borderRadius: 25.0,
                      suffixIcon: IconButton(
                          color: Theme.of(context).primaryColor,
                          iconSize: 25.0,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send,
                          )),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
