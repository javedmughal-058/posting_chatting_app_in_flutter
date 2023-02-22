import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String? messageID;
  String? message;
  String? time;
  MessageModel({
    this.messageID,
    this.message,
    this.time,
  });
  factory MessageModel.fromDocument(Map<String,dynamic> doc){
    return MessageModel(
      messageID: doc['messageID'],
      message: doc['message'],
      time: doc['time'],
    );
  }
}