import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/presentation/screens/fan/add_fan_image.dart';
import 'package:fanchat/presentation/screens/fan/add_fan_video.dart';
import 'package:fanchat/presentation/widgets/fan_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FanScreen extends StatelessWidget {
  const FanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        listener: (context,state){
          if(state is PickFanPostImageSuccessState){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFanImage()));
          }
          if(state is PickFanPostVideoSuccessState){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFanVideo()));
          }
        },
      builder: (context,state){
          var cubit=AppCubit.get(context);
          return Scaffold(
            backgroundColor: AppColors.primaryColor1,
            body: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Stack(
                children: [
                  GridView.count(
                    childAspectRatio: 1/1.3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    children: List.generate(
                        AppCubit.get(context).fans.length, (index) => FanAreaWidget(index: index,)),
                  ),
                ],
              ),
            ),



              floatingActionButton: SpeedDial(
                backgroundColor: AppColors.navBarActiveIcon,
                animatedIcon: AnimatedIcons.menu_close,
                elevation: 1,
                overlayColor: AppColors.myWhite,
                overlayOpacity: 0.0001,
                children: [
                  SpeedDialChild(
                      onTap: (){
                         AppCubit.get(context).pickFanPostVideo();
                      },
                      child: Icon(Icons.video_camera_back,color: Colors.red),
                      backgroundColor: AppColors.myWhite
                  ),
                  SpeedDialChild(
                    onTap: (){
                        AppCubit.get(context).pickFanPostImage();
                    },
                    child: Icon(Icons.image,color: Colors.green,),
                    backgroundColor: AppColors.myWhite,
                  ),
                ],
              )
          );
      },
    );
  }
}
