import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_media/ViewModel/login/login_controller.dart';
import 'package:tech_media/ViewModel/profile/profile_controller.dart';
import 'package:tech_media/ViewModel/signup/signup_controller.dart';
import 'package:tech_media/res/color.dart';
import 'package:tech_media/res/fonts.dart';
import 'package:tech_media/utils/routes/route_name.dart';
import 'package:tech_media/utils/routes/routes.dart';
import 'package:tech_media/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileController(),),
        ChangeNotifierProvider(create: (context) => LogInController(),),
        ChangeNotifierProvider(create: (context) => SignUpController(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "Montserrat",
            primarySwatch: AppColors.primaryMaterialColor,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                color: Colors.indigo,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                    fontSize: 22, color: AppColors.whiteColor)),
            textTheme: const TextTheme(
              headline1: TextStyle(
                  fontSize: 40,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
              headline2: TextStyle(
                  fontSize: 32,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
              headline3: TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
              headline4: TextStyle(
                  fontSize: 25,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
              headline5: TextStyle(
                  fontSize: 22,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w500,
                  height: 1.6),
              headline6: TextStyle(
                  fontSize: 17,
                  fontFamily: AppFonts.sfProDisplayBold,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w700,
                  height: 1.6),
              bodyText1: TextStyle(
                  fontSize: 17,
                  fontFamily: AppFonts.sfProDisplayBold,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w700,
                  height: 1.6),
              bodyText2: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.sfProDisplayRegular,
                  color: AppColors.primaryTextTextColor,
                  height: 1.6),
              caption: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFonts.sfProDisplayBold,
                  color: AppColors.primaryTextTextColor,
                  fontWeight: FontWeight.w700,
                  height: 2.26),
            )),
        home: const SplashScreen(),
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
