import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanchat/business_logic/advertising_cubit/advertising_cubit.dart';
import 'package:fanchat/business_logic/advertising_cubit/advertising_state.dart';
import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/business_logic/shared/local/cash_helper.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/presentation/screens/advertising/advertising_full_post.dart';
import 'package:fanchat/presentation/screens/advertising/advertising_full_video.dart';
import 'package:fanchat/presentation/screens/fan/fan_full_post.dart';
import 'package:fanchat/presentation/screens/fan/fan_full_video.dart';
import 'package:fanchat/presentation/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class AdvertisingAreaWidget extends StatefulWidget {
  int? index;
  AdvertisingAreaWidget({Key? key, this.index}) : super(key: key);

  @override
  State<AdvertisingAreaWidget> createState() => _AdvertisingAreaWidgetState();
}

class _AdvertisingAreaWidgetState extends State<AdvertisingAreaWidget> {
  //VideoPlayerController ?videoPlayerController;
  //Future <void> ?intilize;

  @override
  // void initState() {
  //   videoPlayerController=VideoPlayerController.network(
  //       AdvertisingCubit.get(context).advertising[widget.index!].postVideo!
  //   );
  //   videoPlayerController!.initialize();
  //   videoPlayerController!.setLooping(false);
  //   videoPlayerController!.setVolume(1.0);    super.initState();
  // }
  // @override
  // void dispose() {
  //   videoPlayerController!.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvertisingCubit,AdvertisingState>(
        builder: (context , state){
          return Column(
            children: [
              InkWell(
                  onTap: (){
                    AdvertisingCubit.get(context).toAdvertisingLink(
                        advertisingLink: AdvertisingCubit.get(context).advertising[widget.index!].advertisingLink!
                    );
                  },
                  child: (AdvertisingCubit.get(context).advertising[widget.index!].postImage!="")
                      ?Stack(
                    children: [
                      Material(
                        elevation: 1000,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            height: MediaQuery.of(context).size.height*.25,
                            width: double.infinity,
                            child:  CachedNetworkImage(
                              cacheManager: AppCubit.get(context).manager,
                              imageUrl: "${AdvertisingCubit.get(context).advertising[widget.index!].postImage}",
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      :Stack(
                    children: [
                      Material(
                        elevation: 1000,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            height: MediaQuery.of(context).size.height*.25,
                            width: double.infinity,
                            child:  CachedNetworkImage(
                              cacheManager: AppCubit.get(context).manager,
                              imageUrl: "${AdvertisingCubit.get(context).advertising[widget.index!].advertiseThumbnail}",
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: (){
                            },
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor:Colors.white.withOpacity(.6),
                                child: Icon(Icons.play_arrow,color: AppColors.primaryColor1,size: 15)
                            ),
                          )
                      ),
                    ],
                  )
              ),
            ],
          );
        },
        listener: (context , state){
          if(state is NavigateScreenState){
            // videoPlayerController!.pause();
          }
        });
  }
}
