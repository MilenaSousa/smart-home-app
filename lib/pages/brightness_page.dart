import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home_app/components/icon_item.dart';
import 'package:smart_home_app/consts.dart';

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});

  @override
  State<BrightnessPage> createState() => _BrightnessPageState();
}

class _BrightnessPageState extends State<BrightnessPage> {
  final StreamController _colorIntensity = StreamController<double>.broadcast();

  Color colorSelected = Colors.red;
  double initialValue = 23;

  @override
  void initState() {
    _colorIntensity.sink.add(23.0);
    super.initState();
  }

  @override
  void dispose() {
    _colorIntensity.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        const AppBar(),
        const SizedBox(height: 30),
        Container(
          // color: Colors.red,
          padding: const EdgeInsets.only(left: 24),
          height: 70,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                ItemWidget(icon: Icons.home, label: 'Tudo', isSelected: true),
                ItemWidget(icon: Icons.kitchen, label: 'Cozinha'),
                ItemWidget(icon: Icons.bed, label: 'Quarto 1'),
                ItemWidget(icon: Icons.bed, label: 'Quarto 2'),
                ItemWidget(icon: Icons.shower, label: 'Banheiro'),
                ItemWidget(icon: Icons.chair, label: 'Escritorio'),
                ItemWidget(icon: Icons.tv_sharp, label: 'Sala 1'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Const.secondaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200))),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 250,
                      child: StreamBuilder(
                          stream: _colorIntensity.stream,
                          initialData: 23,
                          builder: (context, snapshot) {
                            return Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(20, 244, 67, 54),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: colorSelected
                                            .withOpacity(snapshot.data / 100),
                                        spreadRadius: 80,
                                        blurRadius: 100)
                                  ]),
                            );
                          }),
                    ),
                    Image.asset(
                      'assets/images/lamp3.png',
                      width: 210,
                    ),
                    CustomSlider(
                      colorIntensity: _colorIntensity,
                      initialValue: initialValue,
                    ),
                    SizedBox(
                      height: 550,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(61, 255, 255, 255),
                                borderRadius: BorderRadius.circular(8)),
                            child: StreamBuilder(
                                stream: _colorIntensity.stream,
                                initialData: 23,
                                builder: (context, snapshot) {
                                  return Text(
                                    "${snapshot.data.ceil()}%",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white),
                                  );
                                }),
                          ),
                          const SizedBox(height: 65),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ColorBtn(
                                color: Colors.yellow,
                                colorSelected: colorSelected,
                                onPress: () {
                                  setState(() {
                                    colorSelected = Colors.yellow;
                                  });
                                },
                              ),
                              ColorBtn(
                                colorSelected: colorSelected,
                                color: const Color.fromARGB(255, 33, 65, 243),
                                onPress: () {
                                  setState(() {
                                    colorSelected =
                                        const Color.fromARGB(255, 33, 65, 243);
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 70,
                                  width: 70,
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(46, 255, 255, 255),
                                  ),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.power_settings_new_rounded,
                                      color: Const.accentColor,
                                      size: 23,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _colorIntensity.sink.add(0.0);
                                  setState(() {
                                    initialValue = 1;
                                  });
                                },
                              ),
                              ColorBtn(
                                colorSelected: colorSelected,
                                color: Colors.red,
                                onPress: () {
                                  setState(() {
                                    colorSelected = Colors.red;
                                  });
                                },
                              ),
                              ColorBtn(
                                colorSelected: colorSelected,
                                color: Colors.white,
                                onPress: () {
                                  setState(() {
                                    colorSelected = Colors.white;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: Const.primaryColor,
      body: body,
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double initialValue;
  const CustomSlider({
    super.key,
    required this.initialValue,
    required StreamController colorIntensity,
  }) : _colorIntensity = colorIntensity;

  final StreamController _colorIntensity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Transform.rotate(
        angle: 0.25,
        child: SleekCircularSlider(
            max: 100,
            initialValue: initialValue,
            appearance: CircularSliderAppearance(
                infoProperties: InfoProperties(
                  modifier: (percentage) => '',
                ),
                customWidths: CustomSliderWidths(
                    trackWidth: 3,
                    handlerSize: 12,
                    progressBarWidth: 3,
                    shadowWidth: 10),
                customColors: CustomSliderColors(
                    dotColor: Const.accentColor,
                    trackColor: const Color.fromARGB(180, 255, 255, 255),
                    shadowColor: Colors.white,
                    progressBarColor: Const.accentColor),
                angleRange: 150,
                startAngle: 180),
            onChange: (double value) {
              _colorIntensity.sink.add(value);
            }),
      ),
    );
  }
}

class ColorBtn extends StatelessWidget {
  final Color color;
  final Function onPress;
  final Color colorSelected;
  const ColorBtn({
    super.key,
    required this.color,
    required this.onPress,
    required this.colorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          height: 32,
          width: 32,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
                color: colorSelected == color ? color : Colors.transparent,
                width: 2),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        onTap: () => onPress());
  }
}

class ItemWidget extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String label;
  const ItemWidget({
    super.key,
    required this.icon,
    this.isSelected = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconItem(
            icon: icon,
            padding: 14,
            size: 20,
            selected: isSelected,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
                fontSize: 10,
                color: isSelected ? Const.accentColor : Colors.black),
          )
        ],
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        margin: const EdgeInsets.only(top: 55),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(left: 0, child: Icon(Icons.arrow_back)),
            Text('Luzes',
                style: TextStyle(
                    color: Const.fontColor1,
                    fontSize: 25,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
