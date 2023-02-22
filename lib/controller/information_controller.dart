

import 'package:get/get.dart';

import '../views/home_page.dart';
import '../views/profile_page.dart';


class InformationController extends GetxController {

  var indexScreen = 0.obs;
  var screens = [
    const Home(),
    const ProfilePage(),
  ].obs;

  var isCollapsed = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }




}