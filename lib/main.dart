import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nkuzi_igbo/apple_sign_in_available.dart';
import 'package:nkuzi_igbo/models/app_model.dart';
import 'package:nkuzi_igbo/models/study.dart';
import 'package:nkuzi_igbo/models/sub_category.dart';
import 'package:nkuzi_igbo/models/test.dart';
import 'package:nkuzi_igbo/models/user_model.dart';
import 'package:nkuzi_igbo/models/category_model.dart';
import 'package:nkuzi_igbo/providers/provider_list.dart';
import 'package:nkuzi_igbo/screens/auth/login_screen.dart';
import 'package:nkuzi_igbo/screens/auth/password_reset_screen.dart';
import 'package:nkuzi_igbo/screens/auth/reset_screen.dart';
import 'package:nkuzi_igbo/screens/auth/reset_success.dart';
import 'package:nkuzi_igbo/screens/auth/signup_screen.dart';
import 'package:nkuzi_igbo/screens/auth/welcome_screen.dart';
import 'package:nkuzi_igbo/screens/home_page.dart';
import 'package:nkuzi_igbo/screens/payment/payment_page.dart';
import 'package:nkuzi_igbo/screens/quiz/quiz_screen_page.dart';
import 'package:nkuzi_igbo/screens/registration_screen.dart';
import 'package:nkuzi_igbo/screens/splash_screen.dart';
import 'package:nkuzi_igbo/screens/static/about_page.dart';
import 'package:nkuzi_igbo/screens/static/terms_page.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'models/progres_model.dart';
import 'utils/theme_data.dart';

void main() async {
  await _openHive();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyApp(),
  ));
}

_openHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocDir = await pp.getApplicationDocumentsDirectory();
  Hive
    ..init(appDocDir.path)
    ..registerAdapter(UserAdapter())
    ..registerAdapter(AppModelAdapter())
    ..registerAdapter(CategoryAdapter())
    ..registerAdapter(ProgressAdapter())
    ..registerAdapter(StudyAdapter())
    ..registerAdapter(SubCategoryAdapter())
    ..registerAdapter(TestAdapter());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        title: 'NkuziIgbo',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        theme: myThemeData(context),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ResetScreen.id: (context) => ResetScreen(),
          PasswordResetScreen.id: (context) => PasswordResetScreen(),
          ResetSuccess.id: (context) => ResetSuccess(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomePage.id: (context) => HomePage(),
          PaymentPage.id: (context) => PaymentPage(),
          SplashScreen.id: (context) => SplashScreen(),
          AboutPage.id: (context) => AboutPage(),
          TermsPage.id: (context) => TermsPage(),
          QuizScreenPage.id: (context) => QuizScreenPage(),
        },
      ),
    );
  }
}
