

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class ChattingController extends GetxController{

  final userRef = FirebaseFirestore.instance.collection('users');
  var check = '1'.obs;
  var check2 = '3'.obs;
  var check3 = '3'.obs;
  var currentUser = UserModel().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();


  }


  Future<void> testing()async {
    DocumentSnapshot<Map<String,dynamic>> doc = await userRef.doc('115233102583713189317').get();
    currentUser.value = UserModel.fromDocument(doc.data() ?? {});
    print("Controller printing ${currentUser.value.userName}");
  }

  Future<void> apiTesting()async {
    print('Api Testing');
  }
  Future<void> apiTesting2()async {
    print('Api Testing2');
  }

}