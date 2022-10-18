import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/business_logic/shared/local/cash_helper.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/presentation/screens/edit_screen/edit_screen.dart';
import 'package:fanchat/presentation/screens/show_home_image.dart';
import 'package:fanchat/presentation/screens/user_profile.dart';
import 'package:fanchat/presentation/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_strings.dart';
import '../screens/comment_screen.dart';
import '../screens/home_screen.dart';

class PostWidget extends StatefulWidget {
  int ?index;
  int? commentIndex;

  PostWidget({Key? key,this.index}) : super(key: key);

  @override
  State<PostWidget> createState() => PostWidgetState();
}

class PostWidgetState extends State<PostWidget> {



  VideoPlayerController? controller;
  Future <void> ?intilize;

  @override
  void initState() {

    // controller = CachedVideoPlayerController.network(
    //     AppCubit.get(context).posts[widget.index!].postVideo!);
    // controller!.initialize();
    // controller!.pause();
    // controller!.setLooping(true);
    // controller!.setVolume(1.0);
    controller=VideoPlayerController.network(
        AppCubit.get(context).posts[widget.index!].postVideo!);
    intilize=controller!.initialize();
    controller!.setLooping(true);
    controller!.setVolume(1.0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(listener: (context,state){
      if(state is NavigateScreenState){
        controller!.pause();
       // videoPlayerController!.pause();
      }
      if(state is PauseVideoState){
        controller!.pause();
        // videoPlayerController!.pause();
      }



    },
      builder: (context,state){

        return Card(
          elevation: 2,
          shadowColor: Colors.grey[150],
          color: AppColors.primaryColor1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0,),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: (){
                        AppCubit.get(context).profileId = '${AppCubit.get(context).posts[widget.index!].userId}';
                        AppCubit.get(context).getAllUsers().then((value) {
                          if(AppCubit.get(context).userModel!.uId!=AppCubit.get(context).posts[widget.index!].userId) {
                            AppCubit.get(context).getUserProfilePosts(id: '${AppCubit.get(context).posts[widget.index!].userId}').then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (_){
                                return UserProfile(
                                  userId: '${AppCubit.get(context).posts[widget.index!].userId}',
                                  userImage: '${AppCubit.get(context).posts[widget.index!].image}',
                                  userName: '${AppCubit.get(context).posts[widget.index!].name}',

                                );
                              }));
                            });
                          }

                        });
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:NetworkImage('${AppCubit.get(context).posts[widget.index!].image}'),
                            radius: 18,
                          ),
                          const SizedBox(width: 7,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(

                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text('${AppCubit.get(context).posts[widget.index!].name}',
                                            overflow: TextOverflow.ellipsis,
                                            style:  TextStyle(
                                                color: AppColors.myWhite,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppStrings.appFont
                                            ),
                                          ),
                                          Text(AppCubit.get(context).getTimeDifferenceFromNow(DateTime.tryParse(AppCubit.get(context).posts[widget.index!].timeSmap!)!),
                                            overflow: TextOverflow.ellipsis,
                                            style:  TextStyle(
                                                fontSize: 12,
                                                color: AppColors.myGrey,
                                                fontFamily: AppStrings.appFont
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     Text('${AppCubit.get(context).posts[widget.index!].dateTime}',
                          //       overflow: TextOverflow.ellipsis,
                          //       style:  TextStyle(
                          //           fontSize: 13,
                          //           color: AppColors.myWhite,
                          //           fontFamily: AppStrings.appFont
                          //       ),
                          //     ),
                          //     const SizedBox(height: 5,),
                          //
                          //   ],
                          // ),
                          const SizedBox(width: 5,),
                          if(AppCubit.get(context).userModel!.uId==AppCubit.get(context).posts[widget.index!].userId)
                          PopupMenuButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  height: 10,
                                  value: 2,
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text('Delete',
                                          style:  TextStyle(
                                              fontSize: 13,
                                              color: AppColors.primaryColor1,
                                              fontFamily: AppStrings.appFont
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                    AppCubit.get(context).deletePost(postId: '${AppCubit.get(context).posts[widget.index!].postId}');
                                  },
                                ),
                              ]
                          )

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5,top: 5),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${AppCubit.get(context).posts[widget.index!].text}',
                          style:  TextStyle(
                              color: AppColors.myWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              fontFamily: AppStrings.appFont
                          ),
                        )),
                  ),
                  const SizedBox(height: 0,),
                  (AppCubit.get(context).posts[widget.index!].postImage!="")
                      ?InkWell(
                        onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_){
                              return ShowHomeImage(image: "${AppCubit.get(context).posts[widget.index!].postImage}");
                            }));
                        },
                        child: Material(
                    elevation: 1000,
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: MediaQuery.of(context).size.height*.25,
                          width: double.infinity,
                          child:  CachedNetworkImage(
                            cacheManager: AppCubit.get(context).manager,
                            imageUrl: "${AppCubit.get(context).posts[widget.index!].postImage}",
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                    ),
                  ),
                      )
                      : (AppCubit.get(context).posts[widget.index!].postVideo !="")
                      ?Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*.4,
                        width: double.infinity,
                        child:FutureBuilder(
                          future: intilize,
                          builder: (context,snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              return AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: VideoPlayer(controller!),
                              );
                            }
                            else{
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },



                        )),
                      //   controller!.value.isInitialized
                      //       ? AspectRatio(
                      //       aspectRatio: controller!.value.aspectRatio,
                      //       child: CachedVideoPlayer(controller!))
                      //       : const Center(child: CircularProgressIndicator())
                      // ),

          // FutureBuilder(
                        //   future: intilize,
                        //   builder: (context,snapshot){
                        //     if(snapshot.connectionState == ConnectionState.done){
                        //       return AspectRatio(
                        //         aspectRatio: videoPlayerController!.value.aspectRatio,
                        //         child: VideoPlayer(videoPlayerController!),
                        //       );
                        //     }
                        //     else{
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }
                        //   },
                        //
                        //
                        //
                        // ),

                      Positioned(
                          top: 10,
                          right: 20,
                          child: InkWell(
                            onTap: (){
                              print('hhfhds');
                              setState((){
                                print('hhfhds 5653');
                                if(controller!.value.isPlaying){
                                  controller!.pause();
                                  isPostPlaying=true;
                                }else{
                                  controller!.play();
                                  isPostPlaying=false;

                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.primaryColor1,
                              radius: 20,
                              child: controller!.value.isPlaying? const Icon(Icons.pause):const Icon(Icons.play_arrow),
                            ),
                          )
                      ),
                    ],
                  )
                      :const SizedBox(width: 0,),
                  const SizedBox(height: 0,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text('${AppCubit.get(context).posts[widget.index!].likes}',
                              style: TextStyle(
                                  color: AppColors.myWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppStrings.appFont
                              ),),
                            IconButton(
                              padding:EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed:(){
                                AppCubit.get(context).likePosts('${AppCubit.get(context).posts[widget.index!].postId}',AppCubit.get(context).posts[widget.index!].likes!);

                                if(CashHelper.getData(key: '${AppCubit.get(context).posts[widget.index!].postId}')==null || CashHelper.getData(key: '${AppCubit.get(context).posts[widget.index!].postId}')==false){
                                  setState(() {
                                    AppCubit.get(context).posts[widget.index!].likes=AppCubit.get(context).posts[widget.index!].likes!+1;
                                  });
                                  AppCubit.get(context).isLike[widget.index!]=true;
                                  CashHelper.saveData(key: '${AppCubit.get(context).posts[widget.index!].postId}',value:AppCubit.get(context).isLike[widget.index!] );
                                  setState(() {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc('${AppCubit.get(context).posts[widget.index!].postId}')
                                        .update({
                                      'likes':AppCubit.get(context).posts[widget.index!].likes
                                    }).then((value){
                                      print('Siiiiiiiiiiiiiiiiiiiiiiii');

                                    });
                                  });

                                }
                                else{
                                  setState(() {
                                    AppCubit.get(context).posts[widget.index!].likes=AppCubit.get(context).posts[widget.index!].likes!-1;

                                  });
                                  AppCubit.get(context).isLike[widget.index!]=false;
                                  CashHelper.saveData(key: '${AppCubit.get(context).posts[widget.index!].postId}',value:AppCubit.get(context).isLike[widget.index!] );
                                  setState(() {
                                    FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc('${AppCubit.get(context).posts[widget.index!].postId}')
                                        .update({
                                      'likes':AppCubit.get(context).posts[widget.index!].likes
                                    }).then((value){
                                      printMessage('This is right ${AppCubit.get(context).posts[widget.index!].likes}');
                                      print('Siiiiiiiiiiiiiiiiiiiiiiii');

                                    });
                                  });

                                }
                              },
                              icon: CashHelper.getData(key: '${AppCubit.get(context).posts[widget.index!].postId}')==null ?
                              Icon(Icons.favorite_outline,color: AppColors.myWhite,size: 20):CashHelper.getData(key: '${AppCubit.get(context).posts[widget.index!].postId}') ?Icon(Icons.favorite,color: AppColors.myGrey,size: 20):
                              Icon(Icons.favorite_outline,color: AppColors.myWhite,size: 20)),
                          ],
                        ),
                        const SizedBox(width: 15,),
                        Row(
                          children: [
                             Text('${AppCubit.get(context).posts[widget.index!].comments}',
                             style: TextStyle(
                            color: AppColors.myWhite,
                            fontSize: 13,
                                 fontWeight: FontWeight.w500,
                                 fontFamily: AppStrings.appFont
                            ),),
                            IconButton(
                              padding:EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed:(){
                                AppCubit.get(context).getComment('${AppCubit.get(context).posts[widget.index!].postId}');
                                Navigator.push(context, MaterialPageRoute(builder: (_){
                                  return CommentScreen(postId: '${AppCubit.get(context).posts[widget.index!].postId}');
                                }));
                              },
                              icon: Icon(Icons.mode_comment_outlined,color: AppColors.myGrey,size: 20),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}