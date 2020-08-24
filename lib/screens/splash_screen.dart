import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nkuzi_igbo/helpers/background_image_container.dart';
import 'package:nkuzi_igbo/models/app_model.dart';
import 'package:nkuzi_igbo/models/user_model.dart';
import 'package:nkuzi_igbo/providers/auth_provider.dart';
import 'package:nkuzi_igbo/repository/hive_repository.dart';
import 'package:nkuzi_igbo/screens/auth/welcome_screen.dart';
import 'package:nkuzi_igbo/screens/home_page.dart';
import 'package:nkuzi_igbo/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  HiveRepository _hiveRepository = HiveRepository();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
    _prepareAppState();
  }

  _prepareAppState() async {
    await HiveRepository.openHives([kUserName, kAppDataName]);
    User user;
    AppModel appModel;
    try {
      user = _hiveRepository.get<User>(key: 'user', name: kUserName);
      appModel =
          _hiveRepository.get<AppModel>(key: 'appModel', name: kAppDataName);
    } catch (ex) {
      print(ex);
    }
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          WelcomeScreen.id, (Route<dynamic> route) => false);
    } else {
      Auth.authProvider(context).setUser(user);
      Auth.authProvider(context).setToken(appModel.token);
      Navigator.of(context).pushNamedAndRemoveUntil(
          appModel?.lastRoute ?? HomePage.id, (Route<dynamic> route) => false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImageContainer(
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
        image: AssetImage('$kImageUrl/starting-page.png'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  height: controller.value * 100,
                )),
            SizedBox(
              width: double.infinity,
            ),
            Expanded(
                flex: 1,
                child: Text(
                  'Igbo Tutor Powered by Gtonia',
                  style: TextStyle(color: Color(0XFFE20303), fontSize: 11),
                ))
          ],
        ),
      ),
    );
  }
}
