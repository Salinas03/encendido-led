import 'package:flutter/material.dart';

class PantallaApagado extends StatefulWidget {
  const PantallaApagado({super.key});

  @override
  State<PantallaApagado> createState() => _PantallaApagadoState();
}

class _PantallaApagadoState extends State<PantallaApagado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/galaxy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/img/FOCO_Apagado.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _Encendido,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.power_settings_new,
                    size: 36.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //método para prender apagar led
  void _Encendido() {
    Navigator.pushNamed(context, 'white');
  }
}
