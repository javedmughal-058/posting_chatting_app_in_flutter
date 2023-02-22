
import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posting_chatting_app_in_flutter/model/message_model.dart';
import 'package:posting_chatting_app_in_flutter/model/user_model.dart';

class ChattingController extends GetxController{

  var userId = ''.obs;
  var isAuth = false.obs;
  var dateValue = DateTime.now().toString();
  var currentUser = UserModel().obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRef = FirebaseFirestore.instance.collection('users');
  final chatRef = FirebaseFirestore.instance.collection('chats');
  var userList = [].obs;
  var chatList = [].obs;
  var conversationList = <MessageModel>[].obs;
  late TextEditingController messageInputText;
  var appVersion = ''.obs;
  var appBuild = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    messageInputText = TextEditingController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if(account !=null){
        userId.value = account.id;
        DocumentReference dc = userRef.doc(userId.value);
        Map<String, dynamic> record={
          "display_name": account.displayName,
          "user_email": account.email,
          "user_followers": '0',
          "user_post": '0',
          "user_status": '1',
          "isAdmin": 'false',
          "date": dateValue,
          "image_url": account.photoUrl,
          "user_id": userId.value,
        };
        dc.set(record).whenComplete((){
          const AdvanceSnackBar(
            message: "Successfully Login",
            mode: Mode.ADVANCE,
            duration: Duration(seconds: 3),
            bgColor: Colors.green,
            textColor: Colors.white,
          );
          getCurrentUser().then((value) =>isAuth.value = true);
        });

      }
      else {
        isAuth.value = false;
      }
    });
    getAppVersion();
  }

  Future<void> getCurrentUser() async{
    DocumentSnapshot<Map<String,dynamic>> doc = await userRef.doc(userId.value).get();
    currentUser.value = UserModel.fromDocument(doc.data() ?? {});
    print("Controller printing ${currentUser.value.userName}");
  }
  Future<void> getUsers() async{
    userList.clear();
    userRef.get().then((value){
      for (var element in value.docs) {
        if(element.data()['user_id']!=userId.value){
          userList.add(element.data());
        }
      }
    });
  }
  Future<void> getChats() async {
    chatRef.get().then((value){
      for (var element in value.docs) {
        chatList.add(element.data()['chatId']);
      }
    });
  }


  Future<void> showChat(String senderId, String receiverID) async {
    if(chatList.isEmpty){
      DocumentReference dc = chatRef.doc('$senderId+$receiverID');
      Map<String, dynamic> chatRecord={
        "chatId" : '$senderId+$receiverID',
        "senderID": senderId,
        "receiverID": receiverID,
      };
      dc.set(chatRecord).whenComplete((){});
    }
    else{
      for (int c=0; c<=chatList.length; c++){
        if(chatList[c] != senderId+receiverID || chatList[c] != receiverID+senderId){
          DocumentReference dc = chatRef.doc('$senderId+$receiverID');
          Map<String, dynamic> chatRecord={
            "chatId" : '$senderId+$receiverID',
            "senderID": senderId,
            "receiverID": receiverID,
          };
          dc.set(chatRecord).whenComplete((){});
        }
        else{

        }
      }
    }



  }

  Future<void> startChatting(String chatID) async {
    QuerySnapshot<Map<String,dynamic>> doc = await chatRef.doc(chatID).collection('messages').get();
    // doc.docs.forEach((e) {
    //   print(e.data());
    //   conversationList.value = MessageModel.fromDocument(e.data());
    //   // conversationList.add(MessageModel.fromDocument(e.data()));
    // });
    conversationList.value = doc.docs.map((e) => MessageModel.fromDocument(e.data())).toList();
    // print("Chat printing--------- ${conversationList[0].message}");
  }

  Future<void> getAppVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuild.value = packageInfo.buildNumber;
  }
  void login() {
    googleSignIn.signIn();
  }
  void logout() {
    googleSignIn.signOut();
  }

}