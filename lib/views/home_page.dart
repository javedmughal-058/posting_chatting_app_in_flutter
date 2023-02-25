
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posting_chatting_app_in_flutter/controller/chatting_controller.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ChattingController chatController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.getUserPost();
  }
  @override
  Widget build(BuildContext context) {

    Future<void> _refresh() async{
      await chatController.getUserPost();
    }
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:  Obx(()=>chatController.postDownloading.value?
          const LinearProgressIndicator() :
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:chatController.postRecordList.isEmpty
                ? const Center(child: Text('No Post Yet'))
                : ListView.builder(
                  itemCount: chatController.postRecordList.length,
                  itemBuilder: (context, index){
                    return Container(
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InteractiveViewer(
                          panEnabled: false, // Set it to false
                          boundaryMargin: const EdgeInsets.all(100),
                          minScale: 0.5,
                          maxScale: 2,
                          child: Image.network(chatController.postRecordList[index].posturl!,fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width*0.45,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border)),
                                Text('${chatController.postRecordList[index].likes}')
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: (){}, icon: const Icon(Icons.comment)),
                                Text('${chatController.postRecordList[index].comments}')
                              ],
                            ),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.share))
                          ],
                        )
                      ],
                    ),
                  );
                }),),
        ),
      ),
    );
  }
}
