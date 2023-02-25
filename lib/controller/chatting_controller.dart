
import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:posting_chatting_app_in_flutter/model/message_model.dart';
import 'package:posting_chatting_app_in_flutter/model/post_model.dart';
import 'package:posting_chatting_app_in_flutter/model/user_model.dart';

class ChattingController extends GetxController{

  var userId = ''.obs;
  var isAuth = false.obs;
  var isLoading =false.obs;
  var dateValue = DateTime.now().toString();
  var currentUser = UserModel().obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRef = FirebaseFirestore.instance.collection('users');
  final chatRef = FirebaseFirestore.instance.collection('chats');
  final postRef = FirebaseFirestore.instance.collection('posts');
  var userList = [].obs;
  var chatList = [].obs;
  var conversationList = <MessageModel>[].obs;
  late TextEditingController messageInputText;
  var appVersion = ''.obs;
  var appBuild = ''.obs;
  var chatID = ''.obs;
  var postDownloading = true.obs;
  var postRecordList = <PostModel>[].obs;
  var showAllPost = false.obs;
  var postReferenceUserList = [].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    messageInputText = TextEditingController();
    googleSignIn.onCurrentUserChanged.listen((account) {
      // isLoading.value = true;
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

          // const AdvanceSnackBar(
          //   message: "Successfully Login",
          //   mode: Mode.ADVANCE,
          //   duration: Duration(seconds: 3),
          //   bgColor: Colors.green,
          //   textColor: Colors.white,
          // );
          getCurrentUser().then((value) {
            isLoading.value = false;
            isAuth.value = true;
            getUserPost().then((value) {
              postDownloading.value = false;
            });
          });

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
  Future<void> getUserPost() async{
    postRecordList.clear();
    QuerySnapshot<Map<String,dynamic>> doc = await postRef.doc(userId.value).collection('userPosts').get();
    postRecordList.value = doc.docs.map((e) => PostModel.fromDocument(e.data())).toList();
    print("post printing ${postRecordList[0].posturl}");
  }
  Future<void> getAllPost() async{
    postReferenceUserList.clear();
    postDownloading.value = true;
    postRecordList.clear();
    await postRef.get().then((value){
      for (var element in value.docs) {
        postReferenceUserList.add(element.data()['postUserID']);
      }
      print(postReferenceUserList.length);
    });
    print(postReferenceUserList[0]);
    for(int i=0; i<postReferenceUserList.length; i++){
      QuerySnapshot<Map<String,dynamic>> doc2 = await postRef.doc(postReferenceUserList[i]).collection('userPosts').get();
      postRecordList.value = doc2.docs.map((e) => PostModel.fromDocument(e.data())).toList();
    }
    postDownloading.value = false;

    print("post printing ${postRecordList[0].posturl}");
  }
  Future<void> getUsers() async{
    userList.clear();
    userRef.get().then((value){
      getChats();
      for (var element in value.docs) {
        if(element.data()['user_id']!=userId.value){
          userList.add(element.data());
        }
      }
    });
  }
  Future<void> getChats() async {
    chatList.clear();
    chatRef.get().then((value){
      for (var element in value.docs) {
        chatList.add(element.data()['chatId']);

      }
      print(chatList);
    });
  }


  Future<void> showChat(String senderId, String receiverID, String senderImage, String senderName) async {

    chatID.value = '$senderId+$receiverID';
    print('Sender------$senderId');
    print('receiver----$receiverID');
    if(chatList.isEmpty){
      print('here');
      DocumentReference dc = chatRef.doc(chatID.value);
      Map<String, dynamic> chatRecord={
        "chatId" : chatID.value,
        "senderName": senderName,
        "receiverName": currentUser.value.userName,
        "receiverImage": currentUser.value.userImage,
        "senderImage": senderImage,
      };
      dc.set(chatRecord).whenComplete((){});
    }
    else{
      for (int c=0; c<chatList.length; c++){
        // print(chatList[c]);
        if(chatList[c] == '$senderId+$receiverID' || chatList[c] == '$receiverID+$senderId'){
          print('if');
          var splitData = chatList[c].toString().split('+');
          print(splitData);
          if(splitData[0] == senderId){
            print('match');
            chatID.value = '${splitData[0]}+${splitData[1]}';
          }
          else if(splitData[0] == receiverID){
            chatID.value = '${splitData[0]}+${splitData[1]}';
          }
          print(chatID.value);
          startChatting(chatID.value);
          break;
        }
        else{
          print('else');
          DocumentReference dc = chatRef.doc(chatID.value);
          Map<String, dynamic> chatRecord={
            "chatId" : chatID.value,
            "senderName": senderName,
            "receiverName": currentUser.value.userName,
            "receiverImage": currentUser.value.userImage,
            "senderImage": senderImage,
          };
          dc.set(chatRecord).whenComplete((){});
        }
      }
    }



  }
  Future<void> startChatting(String chatID) async {
    QuerySnapshot<Map<String,dynamic>> doc = await chatRef.doc(chatID).collection('messages').get();
    conversationList.value = doc.docs.map((e) => MessageModel.fromDocument(e.data())).toList();
  }
  Future<void> sendMessage(String userId) async {
    DocumentReference dc = chatRef.doc(chatID.value).collection('messages').doc();
    Map<String, dynamic> addMessage={
      "message": messageInputText.text,
      "messageID": userId,
      "time": DateTime.now().toString(),
    };
    dc.set(addMessage).then((value) {
      messageInputText.clear();
      startChatting(chatID.value);
    });
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