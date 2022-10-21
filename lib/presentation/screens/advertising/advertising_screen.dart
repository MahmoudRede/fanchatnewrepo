import 'package:fanchat/business_logic/advertising_cubit/advertising_cubit.dart';
import 'package:fanchat/business_logic/advertising_cubit/advertising_state.dart';
import 'package:fanchat/business_logic/shared/local/cash_helper.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/presentation/paypal/advertiseNavAds.dart';
import 'package:fanchat/presentation/screens/advertising/add_advertising_image.dart';
import 'package:fanchat/presentation/screens/advertising/add_advertising_video.dart';
import 'package:fanchat/presentation/widgets/advertising_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AdvertisingScreen extends StatelessWidget {
  const AdvertisingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvertisingCubit,AdvertisingState>(
      listener: (context,state){
        if(state is PickAdvertisingPostImageSuccessState){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAdvertisingImage()));
        }
        if(state is PickAdvertisingPostVideoSuccessState){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAdvertisingVideo()));
        }
      },
      builder: (context,state){
        var cubit=AdvertisingCubit.get(context);
        return Scaffold(
            // backgroundColor: AppColors.primaryColor1,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/public_chat_image.jpeg')
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    ListView.separated(
                        itemBuilder: (context,index){
                          return AdvertisingAreaWidget(index: index,);
                        },
                        separatorBuilder: (context,index){
                          return Column(
                            children: [
                              SizedBox(height: 10,),
                              Divider(
                                color: Colors.white,
                                height: 2,
                              ),
                              SizedBox(height: 10,),

                            ],
                          );
                        },
                        itemCount: AdvertisingCubit.get(context).advertising.length
                    ),
                  ],
                ),
              ),
            ),



            floatingActionButton:SpeedDial(
              backgroundColor: AppColors.navBarActiveIcon,
              animatedIcon: AnimatedIcons.menu_close,
              elevation: 1,
              overlayColor: AppColors.myWhite,
              overlayOpacity: 0.0001,

              children: [
                SpeedDialChild(
                    onTap: (){
                      if(CashHelper.getData(key: 'advertise') == true){
                        AdvertisingCubit.get(context).pickAdvertisingPostVideo();
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdsNav()));
                      }

                    },
                    child: Icon(Icons.video_camera_back,color: Colors.red),
                    backgroundColor: AppColors.myWhite
                ),
                SpeedDialChild(
                  onTap: (){
    if(CashHelper.getData(key: 'advertise') == true){
      AdvertisingCubit.get(context).pickAdvertisingPostImage();
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdsNav()));
    }

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
