

import 'package:get/get.dart';

class ChattingController extends GetxController{


  var check = '1'.obs;
  var check2 = '3'.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();


  }


  Future<void> testing()async {
    print('data');
  }

  Future<void> apiTesting()async {
    print('Api Testing');
  }

}