import 'dart:convert';

import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_home_app/components/icon_item.dart';
import 'package:smart_home_app/components/splash_screen.dart';
import 'package:smart_home_app/consts.dart';
import 'package:smart_home_app/models/home_settings.dart';
import 'package:smart_home_app/models/home_settings_widget.dart';
import 'package:smart_home_app/repository/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService firebaseService = FirebaseService();
  bool frontDoorIsLocked = true;
  bool showSplashScreen = true;
  double opacityEffect = 0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3500),
        () => setState(() => showSplashScreen = false));

    Future.delayed(const Duration(milliseconds: 3700),
        () => setState(() => opacityEffect = 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        MainAppBar(firebaseService: firebaseService),
        const SizedBox(height: 40),
        const ConnectDevicesWidget(),
        StreamBuilder(
            stream: firebaseService.getSettingsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                final homeSettings = HomeSettings.fromJson(snapshot.data);

                return AnimatedOpacity(
                  opacity: opacityEffect,
                  duration: Duration(milliseconds: 1000),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    height: 350,
                    child: GridView.builder(
                        itemCount: homeSettings.widgetSettings.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 2 / 1.65,
                                maxCrossAxisExtent: 190),
                        itemBuilder: (context, index) {
                          return CustomWidget(
                            settings: homeSettings.widgetSettings[index],
                          );
                        }),
                  ),
                );
              }
            }),
        const SizedBox(height: 20),
        const Spacer(),
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60), topLeft: Radius.circular(60))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PORTA DA FRENTE',
                    style: TextStyle(
                        color: Const.fontColor2,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        letterSpacing: 1.1),
                  ),
                  StreamBuilder(
                      stream: firebaseService.getSettingsStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('Erro de carregamento');
                        }
                        final settings = HomeSettings.fromJson(snapshot.data);
                        return Text(
                          settings.frontDoorIsLocked
                              ? 'Porta Trancada'
                              : 'Porta Destrancada',
                          style: TextStyle(
                            color: Const.fontColor1,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          ),
                        );
                      })
                ],
              ),
              const Spacer(),
              InkWell(
                child: IconItem(
                  icon: frontDoorIsLocked ? Icons.lock_open : Icons.lock,
                  size: 24,
                  bgColor: Const.primaryColor,
                ),
                onTap: () {
                  firebaseService.setFrontDoor(frontDoorIsLocked);
                  setState(() => frontDoorIsLocked = !frontDoorIsLocked);
                },
              )
            ],
          ),
        )
      ],
    );

    return Scaffold(
        body: showSplashScreen ? SplashScreen() : body,
        backgroundColor: Const.primaryColor);
  }
}

class MainAppBar extends StatelessWidget {
  final FirebaseService firebaseService;
  const MainAppBar({
    super.key,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Home',
                style: TextStyle(
                    color: Const.fontColor1,
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              StreamBuilder(
                  stream: firebaseService.getSettingsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('Error');
                    }

                    final settings = HomeSettings.fromJson(snapshot.data);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS: ',
                          style: TextStyle(
                              color: Const.fontColor2,
                              fontSize: 12,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          settings.generalStatusIsOk ? 'ONLINE' : 'OFFLINE',
                          style: TextStyle(
                              color: settings.generalStatusIsOk
                                  ? const Color.fromARGB(255, 29, 215, 97)
                                  : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    );
                  }),
            ],
          ),
          const Spacer(),
          const IconItem(icon: Icons.videocam)
        ],
      ),
    );
  }
}

class ConnectDevicesWidget extends StatelessWidget {
  const ConnectDevicesWidget({
    super.key,
  });

  item(IconData icon, {isAddButton = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isAddButton ? Colors.white : const Color(0xFF6294F5),
          borderRadius: BorderRadius.circular(8)),
      child: Icon(
        icon,
        size: 22,
        color: isAddButton ? Const.accentColor : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          color: Const.secondaryColor,
          borderRadius: BorderRadius.circular(Const.borderRadiusMainWidget)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            "Connect device",
            style: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241),
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            "Connect new device with this app",
            style: TextStyle(
                color: Color.fromARGB(255, 241, 241, 241), fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              item(Icons.computer),
              item(Icons.phone_android),
              item(Icons.tv),
              item(Icons.battery_1_bar_outlined),
              item(Icons.wysiwyg_sharp),
              item(Icons.add, isAddButton: true)
            ],
          ),
        ],
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final HomeSettingsWidget settings;

  const CustomWidget({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Const.borderRadiusMainWidget),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      minRadius: 20,
                      backgroundColor: Const.primaryColor,
                      child: Icon(
                        IconData(settings.iconCode,
                            fontFamily: 'MaterialIcons'),
                        size: 18,
                      )),
                  const Spacer(),
                  Container(
                    width: 35,
                    height: 22,
                    decoration: BoxDecoration(
                        color: Const.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Transform.scale(
                      scale: 0.70,
                      child: Switch(
                        value: settings.activated,
                        activeColor: Const.accentColor,
                        inactiveTrackColor: Const.primaryColor,
                        activeTrackColor: Const.primaryColor,
                        onChanged: (value) => {},
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settings.label,
                    style: TextStyle(
                        color: Const.fontColor2,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  AnimatedDigitWidget(
                    duration: const Duration(milliseconds: 1100),
                    value: int.parse(settings.value),
                    suffix: settings.suffix,
                    textStyle: TextStyle(
                        color: Const.fontColor1,
                        fontSize: 17,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () => Navigator.pushNamed(context, '/brigthness-page'));
  }
}
