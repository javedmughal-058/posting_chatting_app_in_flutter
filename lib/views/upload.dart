import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';
import 'package:posting_chatting_app_in_flutter/controller/information_controller.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}
class _UploadState extends State<Upload> {
  final InformationController _informationController = Get.find();
  final ChattingController _chattingController = Get.find();
  File? imageFile;


  String postId = const Uuid().v4();



  @override
  Widget build(BuildContext context) {
    compressImage() async{
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      Im.Image? image = Im.decodeImage(imageFile!.readAsBytesSync());
      final compressedFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(image!, quality: 85));
      setState(() {
        imageFile = compressedFile;
      });
    }
    uploadFile(imageFile) async{
     FirebaseStorage.instance.ref().child("post_$postId.jpg").putFile(imageFile).whenComplete(() async {
       print('post uploaded');
       final String downloadUrl = await FirebaseStorage.instance.ref().child("post_$postId.jpg").getDownloadURL();

         print(downloadUrl);
         Map<String, dynamic> postValue= {
           'posturl': downloadUrl,
           'likes' : '0',
           'comments': '0',
         };
         DocumentReference dc1 = _chattingController.postRef.doc(_chattingController.userId.value);
          dc1.set({"postUserID": _chattingController.userId.value}).whenComplete(() {});
         DocumentReference dc = _chattingController.postRef.doc(_chattingController.userId.value).collection('userPosts').doc();
         dc.set(postValue).whenComplete(() {
           imageFile == null;
           _informationController.isUploading.value = false;
           _informationController.showUploadPost.value = false;
           print(_informationController.showUploadPost.value);
         });


     });
    }
    submitPost() async{
      await compressImage();
      await uploadFile(imageFile);

    }
    setState(() {

    });
    return Scaffold(
        body: Obx(()=>Container(
            child: _informationController.showUploadPost.value == false
                ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {
                          _getFromGallery();
                        },
                        child: const Text("Pick from Gallery"),
                      ),
                      Container(
                        height: 40.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: () {
                          _getFromCamera();
                        },
                        child: const Text("Pick from Camera"),
                      )
                    ],
                  ),
            )
                : Column(
                  children: [
                    _informationController.isUploading.value ? const LinearProgressIndicator() : const SizedBox(),
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: (){
                          _informationController.isUploading.value = true;
                         submitPost();
                        }, child: const Text('Post'))
                  ],
            ))),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _informationController.showUploadPost.value = true;
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _informationController.showUploadPost.value = true;
      setState(() {
        imageFile = File(pickedFile.path);

      });
    }
  }

}