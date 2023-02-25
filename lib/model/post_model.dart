import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String? comments;
  String? likes;
  String? posturl;
  PostModel({
    this.comments,
    this.likes,
    this.posturl,
  });
  factory PostModel.fromDocument(Map<String,dynamic> doc){
    return PostModel(
      comments: doc['comments'],
      likes: doc['likes'],
      posturl: doc['posturl'],
    );
  }
}