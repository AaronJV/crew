import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';

makeOceanTasks(BuildContext context, int? tasks) {
  if (tasks == null) {
    return const SizedBox();
  }

  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/ocean/difficulty.png'),
              fit: BoxFit.cover),
        ),
      ),
      Text(
        tasks.toString(),
        style: TextStyle(
            color: Color(0xFFCD1414),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(
                  blurRadius: 2,
                  color: Colors.black.withAlpha(127),
                  offset: Offset.fromDirection(0.25 * pi, 2))
            ]),
      )
    ],
  );
}

class CrewTheme {
  final MaterialColor primaryColor;
  final String backgroundAsset;
  final String passMarkerAsset;
  final String failMarkerAsset;
  final Color missionBackgound;
  final Color missionBackgroundAlternate;
  final Color? textAccentColor;

  late final Widget Function(BuildContext, int?) getTasksWidget;

  CrewTheme(
      {required this.primaryColor,
      required this.backgroundAsset,
      required this.passMarkerAsset,
      required this.failMarkerAsset,
      required this.missionBackgound,
      required this.missionBackgroundAlternate,
      this.textAccentColor,
      required Widget Function(BuildContext, int?) taskBuilder}) {
    getTasksWidget = taskBuilder;
  }

  ThemeData getThemeData() {
    return ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor),
        textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: 14,
                color: textAccentColor ?? primaryColor,
                fontWeight: FontWeight.normal),
            headline5: TextStyle(
                fontSize: 14,
                color: textAccentColor ?? primaryColor,
                fontWeight: FontWeight.bold)));
  }

  static CrewTheme getOceanTheme() => CrewTheme(
      primaryColor: createMaterialColor(Colors.blue[900]!),
      textAccentColor: Colors.blue[900],
      missionBackgound: Color(0xFFCDDEEC),
      missionBackgroundAlternate: Color(0xFFB9C5E0),
      backgroundAsset: 'assets/images/ocean/background.jpg',
      passMarkerAsset: 'assets/images/ocean/pass-marker.png',
      failMarkerAsset: 'assets/images/ocean/fail-marker.png',
      taskBuilder: (c, t) => makeOceanTasks(c, t));

  static CrewTheme getSpaceTheme() => CrewTheme(
      primaryColor: Colors.blueGrey,
      textAccentColor: Color.fromARGB(255, 210, 35, 42),
      missionBackgound: Color(0xFFE6E3D8),
      missionBackgroundAlternate: Color(0xFFCFC9B3),
      backgroundAsset: 'assets/images/space/background.jpg',
      passMarkerAsset: 'assets/images/space/pass-marker.png',
      failMarkerAsset: 'assets/images/space/fail-marker.png',
      taskBuilder: (context, tasks) {
        if (tasks == null) {
          return const SizedBox();
        }
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: 30,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0.5,
                    offset: Offset(2, 2))
              ]),
          child: Text(
            tasks.toString(),
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.indigo[900]),
          ),
        );
      });
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
