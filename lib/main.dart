import 'package:bloc/bloc.dart';
import 'package:fanchat/business_logic/advertising_cubit/advertising_cubit.dart';
import 'package:fanchat/business_logic/cubit/app_cubit.dart';
import 'package:fanchat/business_logic/shared/local/cash_helper.dart';
import 'package:fanchat/constants/app_colors.dart';
import 'package:fanchat/constants/app_strings.dart';
import 'package:fanchat/firebase_options.dart';
import 'package:fanchat/presentation/layouts/home_layout.dart';
import 'package:fanchat/presentation/screens/edit_profie_screen.dart';
import 'package:fanchat/presentation/screens/fan/fan_full_post.dart';
import 'package:fanchat/presentation/screens/messages_details.dart';
import 'package:fanchat/presentation/screens/posts/add_new_image.dart';
import 'package:fanchat/presentation/screens/posts/add_new_video.dart';
import 'package:fanchat/presentation/screens/posts/add_text_post.dart';
import 'package:fanchat/presentation/screens/profile_area/profile_screen.dart';
import 'package:fanchat/presentation/screens/register_screen.dart';
import 'package:fanchat/presentation/screens/splash_screen.dart';
import 'package:fanchat/presentation/widgets/shared_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'business_logic/bloc/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await CashHelper.init();
 // AppStrings.uId = '1832855570382325';
  AppStrings.uId = CashHelper.getData(key: 'uid');

  printMessage('userId is: ${AppStrings.uId}');


  Bloc.observer = MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {

    return MultiBlocProvider(
        providers:[
          BlocProvider(create: (context)=>AppCubit()..getUser()..getCountries()..getProfilePosts()..getPosts()..getAllUsers()..getFanPosts()..periodic()),
          BlocProvider(create: (context)=>AdvertisingCubit()..getAdvertisingPosts()),
        ],
        child: FirebasePhoneAuthProvider(
          child: OverlaySupport(
            child: MaterialApp(
              title: 'fanchat',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                navigationBarTheme: const NavigationBarThemeData(
                  elevation: 1000,
                ),
                primarySwatch: Colors.blue,
                appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarColor: AppColors.primaryColor1,
                  )
                )
              ),
             // initialRoute: 'register',
              routes: {
                '/' :(context)=> (AppStrings.uId != null)
                ?HomeLayout()
            :SplashScreen(),
                'home_layout':(context)=> const HomeLayout(),
               // 'login':(context)=> LoginScreen(),
                'register':(context)=>RegisterScreen(),
                'profile':(context)=> const ProfileScreen(),
                'edit_profile':(context)=>EditProfileScreen(),
                'add_image':(context)=>AddNewImage(),
                'add_video':(context)=>AddNewVideo(),
                'add_text':(context)=>AddTextPost(),
                'fan_post':(context)=>FanFullPost(),
                'message':(context)=>ChatDetails(userModel: AppCubit.get(context).userModel!,),
              },
            ),
          ),
        ),);
  }
}


