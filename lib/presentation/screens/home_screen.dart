import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../data/modles/create_post_model.dart';
import '../widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
    HomeScreen(
      {Key? key, required this.pageHeight, required this.pageWidth})
      : super(key: key);
  final double? pageHeight;
  final double? pageWidth;
   ScrollController _childScrollController = ScrollController();
   ScrollController _parentScrollController = ScrollController();

  @override

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (context,state){
        if(state is PickPostImageSuccessState){
          Navigator.pushNamed(context, 'add_image');
        }
        if(state is PickPostVideoSuccessState){
          Navigator.pushNamed(context, 'add_video');
        }
      },
      builder: (context,state){
        var cubit=AppCubit.get(context);
        return Scaffold(
          backgroundColor:AppColors.primaryColor1,
          body:  AppCubit.get(context).userModel !=null
        ?SingleChildScrollView(
            controller:_parentScrollController ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: cubit.carouselImage.map((e) {
                    return Image(
                      image: NetworkImage(e),
                      width: double.infinity,fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 180,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    viewportFraction: 1,
                    scrollDirection: Axis.horizontal,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayCurve: Curves.fastOutSlowIn
                  ),
                ),
                SizedBox(height: 3,),
                  Container(height: MediaQuery.of(context).size.height*.002,width: MediaQuery.of(context).size.width,color: AppColors.myGrey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, 'add_text');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*.06,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage('${AppCubit.get(context).userModel!.image}'),
                                  radius: 20,
                                ),
                              ),
                               Padding(
                                padding:  EdgeInsets.only(left: 10,top: 0),
                                child: Text('What\'s on your mind....?',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.myWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      fontFamily: AppStrings.appFont
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      SizedBox(height: 3,),
                    ],
                  )
                ),
                Container(height: MediaQuery.of(context).size.height*.002,width: MediaQuery.of(context).size.width,color:AppColors.myGrey),
                const SizedBox(height: 5,),

                const SizedBox(height: 5,),
                NotificationListener(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollUpdateNotification) {
                      if (notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                        debugPrint('Reached the bottom');
                        _parentScrollController.animateTo(
                            _parentScrollController.position.maxScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else if (notification.metrics.pixels ==
                          notification.metrics.minScrollExtent) {
                        debugPrint('Reached the top');
                        _parentScrollController.animateTo(
                            _parentScrollController.position.minScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      }
                    }
                    return true;
                  },
                    child:cubit.posts.length !=0
        ? PaginateFirestore(separator: SizedBox(height: 10,),
        itemBuilderType: PaginateBuilderType.listView,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),//Change types accordingly
        itemBuilder: ( context, documentSnapshot,index) {
        return  PostWidget(
        //invoice: Invoice.fromFirestore(documentSnapshot[index]
        post: PostModel.fromFirestore(documentSnapshot[index]),
          index: index,
        );
        },
        query: FirebaseFirestore.instance.collection('posts')
            .orderBy('dateTime', descending: true),
        // to fetch real-time data
        isLive: true,
        )
                        :Padding(
                          padding: const EdgeInsets.only(top:170),
                          child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.myGrey,
                      ),
                    ),
                        ),
                ),

              ],
            ),
          ) :Center(
            child: CircularProgressIndicator(
              color: AppColors.myGrey,
            ),
          ),


        );
      },
    );
  }
}

// floatingActionButton:SpeedDial(
//   backgroundColor: AppColors.primaryColor1,
//   animatedIcon: AnimatedIcons.menu_close,
//   elevation: 1,
//   overlayColor: AppColors.myWhite,
//   overlayOpacity: 0.0001,
//
//   children: [
//     SpeedDialChild(
//       onTap: (){
//         Navigator.pushNamed(context, 'add_video');
//       },
//       child: Icon(Icons.video_camera_back,color: AppColors.myWhite,),
//       label: 'add video',
//       backgroundColor: AppColors.primaryColor2
//     ),
//     SpeedDialChild(
//       onTap: (){
//         Navigator.pushNamed(context, 'add_image');
//       },
//       child: Icon(Icons.image,color: AppColors.myWhite,),
//       label: 'add image',
//         backgroundColor: AppColors.primaryColor2
//
//     ),
//   ],
// )