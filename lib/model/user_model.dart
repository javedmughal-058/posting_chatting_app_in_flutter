import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? userId;
  String? userName;
  String? date;
  String? userImage;
  String? userIsAdmin;
  String? userEmail;
  String? userFollowers;
  String? userPost;
  String? userStatus;
  UserModel({
    this.userId,
    this.userName,
    this.date,
    this.userImage,
    this.userIsAdmin,
    this.userEmail,
    this.userFollowers,
    this.userPost,
    this.userStatus,
  });
  factory UserModel.fromDocument(Map<String,dynamic> doc){
    return UserModel(
      userId: doc['user_id'],
      userName: doc['display_name'],
      date: doc['date'],
      userImage: doc['image_url'],
      userIsAdmin: doc['isAdmin'],
      userEmail: doc['user_email'],
      userFollowers: doc['user_followers'],
      userPost: doc['user_post'],
      userStatus: doc['user_status'],
    );
  }

//    Map<String, dynamic> toMap() {
//      return {
//        'streetName': streetName,
//        'buildingName': buildingName,
//        'cityName': cityName,
//      };
//    }
//
//    Address.fromMap(Map<String, dynamic> addressMap)
//        : streetName = addressMap["streetName"],
//          buildingName = addressMap["buildingName"],
//          cityName = addressMap["cityName"];
// }
}