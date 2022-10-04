import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/presentation/paypal/advertise.dart';
import 'package:fanchat/presentation/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AdsNav extends StatefulWidget {
  const AdsNav({Key? key}) : super(key: key);

  @override
  State<AdsNav> createState() => _AdsNavState();
}

class _AdsNavState extends State<AdsNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: AppColors.primaryColor1),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/images/lockedfan.json',),
            ),
            Text('Only Advertisers Can Add Their Ads',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5,
                  color: AppColors.myGrey,
                  fontFamily: AppStrings.appFont,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height:25,),
            defaultButton(
                width:MediaQuery.of(context).size.width*.8,
                height: MediaQuery.of(context).size.width*.12,
                buttonColor: AppColors.primaryColor1,
                textColor: AppColors.myWhite,
                buttonText: 'Buy Advertise Package',
                function: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Advertise()));
                })
          ],
        ),
      ),
    );
  }
}
