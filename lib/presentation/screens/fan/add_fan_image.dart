import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/presentation/layouts/home_layout.dart';
import 'package:fanchat/presentation/screens/fan/fan_screen.dart';
import 'package:fanchat/presentation/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddFanImage extends StatefulWidget {
  @override
  State<AddFanImage> createState() => _AddFanImageState();
}

class _AddFanImageState extends State<AddFanImage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit,AppState>(
      listener: (context,state){
        if(state is FanCreatePostSuccessState){
          AppCubit.get(context).currentIndex=2;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeLayout()), (route) => false);
          //Navigator.pop(context);
        }

      },
      builder: (context,state){
        return Scaffold(
          backgroundColor: AppColors.myWhite,
          appBar:AppBar(
            backgroundColor: AppColors.myWhite,
            title: Text('Add Image',style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor1,
                fontFamily: AppStrings.appFont
            )),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.black),
              onPressed: (){
                setState((){
                  print('${AppCubit.get(context).fanPostImage}');
                  Navigator.pop(context);

                });

              },
            ),
            actions: [
              state is FanUploadImagePostLoadingState || state is BrowiseGetPostsLoadingState?
              Center(child:CircularProgressIndicator(),)
                  :Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultButton(
                    textColor: AppColors.myWhite,
                    width: size.width*.2,
                    height: size.height*.05,
                    raduis: 10,
                    function: ()async{
                      if(AppCubit.get(context).fanPostImage == null){
                        print('fan image null');
                      }
                      else{
                        final filesizeLimit = 	5000000 ;  // in bytes // 30 Mega
                        final filesize = await AppCubit.get(context).fanPostImage!.length(); // in bytes
                        final isValidFilesize = filesize < filesizeLimit;
                        if (isValidFilesize) {

                          AppCubit.get(context).uploadFanPostImage(
                              dateTime: DateFormat.yMMMd().format(DateTime.now()),
                              time: DateFormat.Hm().format(DateTime.now()),
                              timeSpam: DateTime.now().toString(),
                              image: AppCubit.get(context).userModel!.image,
                              name: AppCubit.get(context).userModel!.username,
                              text: ""
                          );

                        } else {
                          customToast(title: 'Max Image size is 5 Mb', color: Colors.red);
                        }

                        //AppCubit.get(context).getFanPosts();
                      }

                    },

                    buttonText: 'add',
                    buttonColor: AppColors.primaryColor1
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child:const Opacity(
                    opacity: 1,
                    child:  Image(
                      image: AssetImage('assets/images/imageback.jpg'),
                      fit: BoxFit.cover,
                    ),
                  )
              ),
              Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //
                      //   children:  [
                      //     CircleAvatar(
                      //       backgroundImage: NetworkImage('${AppCubit.get(context).userModel!.image}'),
                      //       radius: 30,
                      //     ),
                      //     const SizedBox(width: 10,),
                      //     Text('${AppCubit.get(context).userModel!.username}',
                      //       style: const TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w500,
                      //           fontFamily: AppStrings.appFont
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 10,),
                      const  SizedBox(height: 0,),
                      (AppCubit.get(context).fanPostImage!= null )
                          ?Expanded(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          child: Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Image(
                              image: FileImage(AppCubit.get(context).fanPostImage!),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      )
                          :Expanded(child: Container(
                        child: Center(child: Text('No Photo Selected Yet',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor1,
                                fontFamily: AppStrings.appFont
                            )
                        )),
                      )),


                    ],
                  )
              ),
            ],
          )
        );
      },
    );
  }
}