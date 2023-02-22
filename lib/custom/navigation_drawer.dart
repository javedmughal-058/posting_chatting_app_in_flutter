
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';
import '../controller/information_controller.dart';
import '../views/about_us.dart';
import '../views/chat.dart';
import '../views/help.dart';
import '../views/setting.dart';
import '../views/upload.dart';
import 'drawer_items.dart';


class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InformationController _informationController = Get.find();
    final ChattingController chatController = Get.find();
    var padding = const EdgeInsets.symmetric(horizontal: 20);
    var safeTop = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    final size = MediaQuery.of(context).size;

    return Obx(()=>SizedBox(
      width: _informationController.isCollapsed.value? size.width*0.15 : size.width*0.65,
        child: Drawer(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white12,
                    padding: const EdgeInsets.symmetric(vertical: 24).add(safeTop),
                    child: buildHeader(_informationController.isCollapsed.value)
                ),
                buildList(items: firstItems, informationController: _informationController, padding: padding),
                const SizedBox(height: 12,),
                const Divider(color: Colors.white70,),
                const SizedBox(height: 12,),
                buildList(
                    indexOffset : firstItems.length,
                    items: secondItems, informationController: _informationController, padding: padding),
                const Spacer(),
                _informationController.isCollapsed.value ? const SizedBox() :
                Text('Version: ${chatController.appVersion.value}', style: const TextStyle(color: Colors.white),),
                const SizedBox(height: 12,),
                buildIsCollapseIcon(context, _informationController),
              ],
            ),
          ),
        )));
  }

  Widget buildHeader(bool isCollapsed) {
    return isCollapsed
        ?Image.asset('assets/images/drawer_logo.png', width: 50,height: 50,)
        :Row(
          mainAxisAlignment: MainAxisAlignment.start,
         children: [
           const SizedBox(width: 12,),
           Image.asset('assets/images/drawer_logo.png', width: 50,height: 50,),
           const SizedBox(width: 24,),
           const Text('Social App', style: TextStyle(color: Colors.white, fontSize: 22),)
     ],
    );
 }
  Widget buildIsCollapseIcon(BuildContext context, _informationController) {
    double size = 52;
    final alignment = _informationController.isCollapsed.value ? Alignment.center : Alignment.centerRight;
    final margin = _informationController.isCollapsed.value  ? null : const EdgeInsets.only(right: 8);
    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            _informationController.isCollapsed.value = ! _informationController.isCollapsed.value;
          },
          child: SizedBox(
              height: size,
              width: _informationController.isCollapsed.value? double.infinity : size,
              child: Icon(_informationController.isCollapsed.value ? Icons.arrow_forward_ios :Icons.arrow_back_ios, color: Colors.white,size: 22,)),
        ),
      ),
    );
  }

  Widget buildList({int indexOffset = 0, required List<DrawerItemModel> items, required InformationController informationController, required EdgeInsets padding}) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        padding: informationController.isCollapsed.value ? EdgeInsets.zero : padding,
        itemBuilder: (context, index) {
          final item = items[index];
          return buildMenuItem(
            isCollapsed: informationController.isCollapsed.value,
            text: item.title,
            icon: item.icon,
            onClick: () => selectItem(context, indexOffset + index, ),
          );
          },
    );
  }
  Widget buildMenuItem({required bool isCollapsed, required String text, required IconData icon, VoidCallback? onClick}) {
    const color = Colors.white;
    final leading = Icon(icon, color: color,size: 24,);
    return Material(
      color: Colors.transparent,
      child: isCollapsed ?
      ListTile(
        title: leading,
        onTap: onClick,
      ) :
      ListTile(
        leading: leading,
        title: Text(text, style: const TextStyle(color: color, fontSize: 14),),
        onTap: onClick,
      ),
    );
  }

  void selectItem(BuildContext context, int index) {
    navigateTo (page) {
      return Navigator.of(context).push(MaterialPageRoute(builder: (context)=> page));
    }
    switch(index){
      case 0:
        navigateTo(const Upload());
        break;
      case 1:
        navigateTo(const ChatScreen());
        break;
      case 2:
        navigateTo(const Setting());
        break;
      case 3:
        navigateTo(const AboutUs());
        break;
      case 4:
        navigateTo(const Help());
        break;
    }
  }
}
