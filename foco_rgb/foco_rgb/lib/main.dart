import 'package:flutter/material.dart';
import 'package:foco_rgb/pages/inicio.dart';
import 'package:foco_rgb/pages/pantalla-Apagado.dart';
import 'package:foco_rgb/pages/white.dart';
import 'package:foco_rgb/pages/rgb.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: NoTransitionsOnPlatform(),
              TargetPlatform.iOS: NoTransitionsOnPlatform(),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (context) => HomePage(),
          'apagado': (context) => PantallaApagado(),
          'white': (context) => white(),
          'rgb': (context) => RGB()
        });
  }
}

class NoTransitionsOnPlatform extends PageTransitionsBuilder {
  const NoTransitionsOnPlatform();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
