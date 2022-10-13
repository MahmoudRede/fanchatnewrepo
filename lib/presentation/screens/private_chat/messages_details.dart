import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/presentation/screens/private_chat/send_video_message.dart';
import 'package:fanchat/presentation/screens/private_chat/sendimage_message.dart';
import 'package:fanchat/presentation/screens/show_home_image.dart';
import 'package:fanchat/presentation/screens/private_chat/my_widget.dart';
import 'package:fanchat/presentation/screens/private_chat/sender_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:voice_message_package/voice_message_package.dart';

import '../../../data/modles/message_model.dart';
import '../../../data/modles/user_model.dart';
 // CachedVideoPlayerController? controllerPrivate;


typedef _Fn = void Function();
Future<String> _getTempPath(String path) async {
  var tempDir = await getTemporaryDirectory();
  var tempPath = tempDir.path;
  return tempPath + '/' + path;
}
class ChatDetails extends StatefulWidget {
  String ?userId;
  String ?userImage;
  String ?userName;
  final onSendMessage;
  ChatDetails({required this.userId,required this.userName,required this.userImage,this.onSendMessage});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  var textMessage = TextEditingController();
  bool isWriting = false;
  String? recordFilePath;
  String statusText='';
  int i=0;
  bool recording=false;
  bool? isComplete;
  bool? uploadingRecord = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {

    isWriting = false;
  }
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      builder: (context)=>Builder(

          builder: (context) {

            if(scrollController.hasClients){
              scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.linear);
            }
            AppCubit.get(context).getMessages(recevierId: widget.userId!);
            return BlocConsumer<AppCubit,AppState>(
              listener: (context,state){
                if(state is PickChatImageSuccessState ){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SendImage(widget.userName,widget.userImage,widget.userId)));
                }
                if(state is PickPrivateChatViedoSuccessState ){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SendVideoMessage(userId: widget.userId,userImage: widget.userImage,userName: widget.userName, )));
                }
              },
              builder: (context,state){
                if(scrollController.hasClients){
                  scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                }
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: AppColors.primaryColor1,
                    elevation: 0,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: (){
                         // controllerPrivate!.pause();
                         // Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: AppColors.myWhite,
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:  NetworkImage('${widget.userImage}'),
                          radius: 22,
                        ),
                        const SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(widget.userName!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppStrings.appFont
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                  body: ConditionalBuilder(
                    builder: (context)=>Column(
                      children: [
                        Expanded(
                          child: Container(
                            height:MediaQuery.of(context).size.height*.83,
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: ListView.separated(
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context , index)
                                {
                                  var message =AppCubit.get(context).messages[index];
                                  if(widget.userId == message.senderId) {
                                    return SenderMessageWidget(index: index,);
                                  }
                                  //receive message
                                    return MyMessageWidget(index: index,);
                                },
                                separatorBuilder: (context , index)=>const SizedBox(height: 15,),
                                itemCount: AppCubit.get(context).messages.length),
                          ),
                        ),
                        recording==true?
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor1
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 5,),
                              Text('${statusText}',style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppStrings.appFont,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.myWhite,
                                    child:IconButton(
                                        onPressed: (){
                                          setState(() {
                                            recording=false;
                                          });
                                          // pauseRecord();
                                        },
                                        icon:Icon(
                                          Icons.delete,
                                          color: AppColors.primaryColor1,
                                          size: 20,
                                        )
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.myWhite,
                                    child:IconButton(
                                        onPressed: (){
                                          pauseRecord();
                                        },
                                        icon: RecordMp3.instance.status == RecordStatus.PAUSE ?Icon(
                                          Icons.radio_button_unchecked_rounded,
                                          color: AppColors.primaryColor1,
                                          size: 20,
                                        ):Icon(
                                          Icons.pause,
                                          color: AppColors.primaryColor1,
                                          size: 20,
                                        )
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.myWhite,
                                    child:  IconButton(
                                        onPressed: (){
                                          setState(() {
                                            recording=false;
                                            AppCubit.get(context).isSend=true;
                                          });
                                          stopRecord();
                                          scrollController.animateTo(
                                            scrollController.position.maxScrollExtent,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeOut,
                                          );
                                          // toogleRecord();
                                        },
                                        icon:  Icon(
                                          Icons.send,
                                          color: AppColors.primaryColor1,
                                          size: 20,
                                        )
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ) ,
                        ):
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*.70,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:AppColors.primaryColor1,
                                        width: 1
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: TextFormField(
                                        onChanged: (v){
                                          setState((){
                                            isWriting=true;
                                          });
                                        },
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        controller: textMessage,
                                        decoration:  const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Write your message...',
                                        ),
                                      )
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: AppColors.primaryColor1
                                    ),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: (){
                                            HapticFeedback.vibrate();
                                            textMessage.text==""
                                                ?{
                                              recording?stopRecord():startRecord(),
                                              AppCubit.get(context).getMessages(recevierId:widget.userId!)
                                            }
                                                :AppCubit.get(context).sendMessage(
                                                recevierId: widget.userId!,
                                                recevierImage:widget.userImage!,
                                                recevierName: widget.userName!,
                                                dateTime: DateTime.now().toString(),
                                                text: textMessage.text);
                                            textMessage.clear();
                                          },
                                          color: AppColors.primaryColor1,
                                          icon: AppCubit.get(context).isSend? const CircularProgressIndicator(color: Colors.white,):  textMessage.text==""?const Icon(Icons.mic,color: Colors.white,size: 18):const Icon(Icons.send,color: Colors.white,size: 18)
                                      ),
                                    )
                                ),
                                const SizedBox(width: 5,),
                                // Container(
                                //     width: 35,
                                //     height: 35,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(50),
                                //         color: AppColors.primaryColor1
                                //     ),
                                //     child: Center(
                                //       child:
                                //       IconButton(
                                //         onPressed: (){
                                //           Scaffold.of(context).showBottomSheet((context) => Container(
                                //             color: AppColors.primaryColor1,
                                //
                                //             width: MediaQuery.of(context).size.width,
                                //             height: MediaQuery.of(context).size.height*.12,
                                //
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: Column(
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   GestureDetector(
                                //                     onTap: (){
                                //                       AppCubit.get(context).pickPostImage();
                                //                     },
                                //                     child: Row(
                                //                       children: [
                                //                         const SizedBox(width: 10,),
                                //                         Icon(
                                //                           Icons.image,
                                //                           color: AppColors.myWhite,
                                //                         ),
                                //                         const SizedBox(width: 10,),
                                //                         const Text('Image',style: TextStyle(
                                //                             color: Colors.white,
                                //                             fontFamily: AppStrings.appFont,
                                //                             fontSize: 18,
                                //                             fontWeight: FontWeight.w500
                                //                         ),),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   const SizedBox(height: 15,),
                                //                   GestureDetector(
                                //                     onTap: (){
                                //                       AppCubit.get(context).pickPostVideo3();
                                //
                                //                     },
                                //                     child: Row(
                                //                       children: [
                                //                         const SizedBox(width: 10,),
                                //                         Icon(
                                //                           Icons.video_collection,
                                //                           color: AppColors.myWhite,
                                //                         ),
                                //                         const SizedBox(width: 10,),
                                //                         const Text('Video',style: TextStyle(
                                //                             color: Colors.white,
                                //                             fontFamily: AppStrings.appFont,
                                //                             fontSize: 18,
                                //                             fontWeight: FontWeight.w500
                                //                         ),),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //
                                //           ));
                                //
                                //         },
                                //         color: AppColors.primaryColor1,
                                //         icon: const ImageIcon(
                                //           AssetImage("assets/images/fanarea.png"),
                                //           color:Colors.white,
                                //           size: 17,
                                //         ),
                                //       ),
                                //     )
                                // ),
                              ],
                            )
                        ),
                      ],
                    ),
                    condition:AppCubit.get(context).messages.length >=0 ,
                    fallback:(context)=>const Center(child: CircularProgressIndicator()),
                  ),
                  floatingActionButton:Padding(
                    padding: const EdgeInsets.only(bottom:0,left:5),
                    child: Container(
                      width: MediaQuery.of(context).size.width*.14,
                      height: MediaQuery.of(context).size.height*.045,

                      child: SpeedDial(
                      backgroundColor: AppColors.primaryColor1,
                      animatedIcon: AnimatedIcons.menu_close,
                      elevation: 1,
                      overlayColor: AppColors.myWhite,
                      overlayOpacity: 0.0001,
                      children: [
                        SpeedDialChild(
                            onTap: (){
                              AppCubit.get(context).pickPostVideo3();
                            },
                            child: Icon(Icons.video_camera_back,color: Colors.red,size: 22),
                            backgroundColor: AppColors.myWhite
                        ),
                        SpeedDialChild(
                          onTap: (){
                            AppCubit.get(context).pickChatImage();
                          },
                          child: Icon(Icons.image,color: Colors.green,size: 22,),
                          backgroundColor: AppColors.myWhite,
                        ),
                      ],
                ),
                    ),
                  ),
                );
              },
            );
          }
      ),
      condition: widget.userName !=null,
      fallback: (context)=>const Center(child: CircularProgressIndicator()),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
  _Fn getRecorderFn() {
    /* if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return () {};
    }*/
    return recording ? stopRecord : startRecord;
  }
  // 1- chech permission
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  // 2- start recors
  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      setState(() {
        recording=true;
      });
      isComplete = false;
      RecordMp3.instance.start(recordFilePath!, (type) {
        statusText = "Record error--->$type";
        setState(() {
        });
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }
  // 3- get file path
  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test1111_${i++}.mp3";
  }
  // 4- stop record
  stopRecord() async {
    print("startRecord11");
    setState(() {
      recording=false;
      uploadingRecord=true;
    });
    bool s = RecordMp3.instance.stop();
    if (s) {
      //statusText = "Record complete";
      //isComplete = true;
      setState(() {});
      if (recordFilePath != null && File(recordFilePath!).existsSync()) {
        print("stopRecord000");
        File recordFile = new File(recordFilePath!);
        uploadRecord(voice: recordFile);
      }
      else
      {
        print("stopRecord111");
      }
    }
  }
  // 5- upload record to firebase
  Future uploadRecord(
      {
        String? recevierId,
        String? dateTime,
        required File voice,
        String? senderId,
      }

      ) async {
    Size size = MediaQuery.of(context).size;
    print("permission uploadRecord1");
    var uuid = const Uuid().v4();
    Reference storageReference =firebase_storage.FirebaseStorage.instance.ref().child('ali/${Uri.file(voice.path).pathSegments.last}');
    await storageReference.putFile(voice).then((value){
      AppCubit.get(context).createVoiceMessage(

        recevierId: widget.userId!,
        recevierImage:widget.userImage!,
        recevierName: widget.userName!,
        dateTime: DateTime.now().toString(),
        voice: voice.path,
      );
      print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyeeeeeeeeeeeeeeeessssssssss');
    }).catchError((error){
      print('nnnnnnnnnnnnnnnnnnnooooooooooooooooooo');
      print(error.toString());

    });
    var url = await storageReference.getDownloadURL();
    print("recording file222");
    print(url);
    widget.onSendMessage(url, "voice", size);

    setState(() {
      uploadingRecord = false;
    });

  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

}