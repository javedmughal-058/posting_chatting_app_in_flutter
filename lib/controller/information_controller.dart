

import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/views/upload.dart';
import '../views/home_page.dart';
import '../views/profile_page.dart';


class InformationController extends GetxController {

  var indexScreen = 0.obs;
  var screens = [
    const Home(),
    Upload(),
    const ProfilePage(),
  ].obs;

  var isCollapsed = false.obs;


  var selectImage = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }




}