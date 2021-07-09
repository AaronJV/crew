import 'package:flutter/material.dart';

enum CrewTypes { Space, Deep_Sea }

extension CrewTypesExtension on CrewTypes {
  String get display =>
      this.toString().replaceFirst('CrewTypes.', '').replaceAll('_', ' ');
}

class CrewType extends InheritedWidget {
  final CrewTypes crewType;
  final void Function(CrewTypes) changeType;

  CrewType(
      {Key? key,
      required this.crewType,
      required Widget child,
      required this.changeType})
      : super(key: key, child: child);

  static CrewType? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CrewType>();
  }

  @override
  bool updateShouldNotify(covariant CrewType oldWidget) {
    return oldWidget.crewType != crewType;
  }
}

var spaceTheme = CrewTheme(
    primaryColor: Colors.blueGrey,
    textAccentColor: Color.fromARGB(255, 210, 35, 42),
    backgroundAsset: 'assets/images/space.jpg');
var oceanTheme = CrewTheme(
    primaryColor: createMaterialColor(Colors.blue[900]!),
    textAccentColor: Colors.blue[900],
    backgroundAsset: 'assets/images/deepSea.jpg');

class CrewTheme {
  final MaterialColor primaryColor;
  final String backgroundAsset;

  Color? textAccentColor;

  CrewTheme(
      {required this.primaryColor,
      required this.backgroundAsset,
      this.textAccentColor});

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

  static CrewTheme of(BuildContext context) {
    CrewType? type = context.dependOnInheritedWidgetOfExactType<CrewType>();
    if (type == null) {
      return spaceTheme;
    }

    switch (type.crewType) {
      case CrewTypes.Deep_Sea:
        return oceanTheme;
      case CrewTypes.Space:
      default:
        return spaceTheme;
    }
  }
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
