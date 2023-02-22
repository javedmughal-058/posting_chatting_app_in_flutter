import 'dart:ui';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';
import '../controller/information_controller.dart';
import '../custom/navigation_drawer.dart';





class Authenticated extends StatefulWidget {
   const Authenticated({Key? key}) : super(key: key);


  @override
  State<Authenticated> createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {

  final ChattingController chatController = Get.find();
  final InformationController _informationController = Get.find();
  int index = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Social App'),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: (){
                  showGeneralDialog(
                    barrierDismissible: true,
                    barrierLabel: '',
                    barrierColor: Colors.black38,
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text('Logout',style: Theme.of(context).textTheme.subtitle2,),
                      content: Text('Are you sure? You want to Logout!',style: Theme.of(context).textTheme.bodyText1,),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Get.back();
                            },
                            child: const Text('No',)
                        ),
                        TextButton(
                          onPressed: (){
                            chatController.googleSignIn.signOut();
                          },
                          child: const Text('Yes',),
                        ),

                      ],
                    ),
                    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
                      child: FadeTransition(
                        child: child,
                        opacity: anim1,
                      ),
                    ),
                    context: context,
                  );

            }, icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                  child: _informationController.screens[index]
              ),
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FloatingNavbar(
                      margin: const EdgeInsets.all(12.0),
                      borderRadius: 10,
                      backgroundColor: Colors.transparent,
                      selectedItemColor: Colors.white,
                      selectedBackgroundColor: Theme.of(context).primaryColor,
                      unselectedItemColor: Theme.of(context).primaryColor,
                      onTap: (int val) {
                        setState(() {
                          index = val;
                        });
                      },
                      currentIndex: index,
                      items: [
                        FloatingNavbarItem(icon: Icons.home, title: 'Home'),
                        FloatingNavbarItem(
                            icon: Icons.chat_bubble_outline, title: 'Profile'),
                      ],
                    ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}