import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async'; // Importación de Timer
import 'pantalla-Apagado.dart'; // Importa la pantalla PantallaApagado
import 'rgb.dart'; // Importa la pantalla RGB
import 'dart:typed_data';

class WhitePage extends StatefulWidget {
  final String deviceName;
  final BluetoothConnection connection;

  const WhitePage({
    required this.deviceName,
    required this.connection,
    Key? key,
  }) : super(key: key);

  @override
  State<WhitePage> createState() => _WhitePageState();
}

class _WhitePageState extends State<WhitePage> {
  List<bool> isSelected = [true, false];
  double intensity = 0.5; // Initial value for intensity
  double temperature = 50; // Initial value for temperature (0-100 scale)
  Color currentColor = Colors.white;

  Timer? debounceTemperature;
  Timer? debounceIntensity;

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
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(8.0),
                selectedBorderColor: Colors.white,
                selectedColor: Colors.white,
                fillColor: const Color.fromARGB(0, 38, 37, 37),
                color: Colors.white,
                constraints: BoxConstraints(
                  minHeight: 60.0,
                  minWidth: 120.0,
                ),
                isSelected: isSelected,
                onPressed: _togglePressed,
                children: const [
                  Text(
                    'White',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'RGB',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 16.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 24.0),
                          activeTrackColor: Color.lerp(
                              Colors.white, Colors.yellow, temperature / 100),
                          inactiveTrackColor: Colors.grey.withOpacity(0.5),
                          thumbColor: Color.fromARGB(255, 198, 190, 116),
                          overlayColor:
                              Color.fromARGB(255, 19, 19, 18).withOpacity(0.2),
                        ),
                        child: Slider(
                          value: temperature,
                          onChanged: (newValue) {
                            setState(() {
                              temperature = newValue;
                              currentColor = Color.lerp(Colors.white,
                                  Colors.yellow, temperature / 100)!;
                            });
                            if (debounceTemperature?.isActive ?? false)
                              debounceTemperature?.cancel();
                            debounceTemperature =
                                Timer(const Duration(milliseconds: 500), () {
                              _sendTemperature(newValue.toInt());
                            });
                          },
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: 'Temperatura',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Image.asset(
                      'assets/img/FOCO.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 16.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 24.0),
                          activeTrackColor:
                              Color.lerp(Colors.grey, Colors.white, intensity),
                          inactiveTrackColor: Colors.grey.withOpacity(0.5),
                          thumbColor: Color.fromARGB(255, 134, 134, 134),
                          overlayColor: Colors.white.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: intensity,
                          onChanged: (newValue) {
                            setState(() {
                              intensity = newValue;
                            });
                            if (debounceIntensity?.isActive ?? false)
                              debounceIntensity?.cancel();
                            debounceIntensity =
                                Timer(const Duration(milliseconds: 500), () {
                              _sendIntensity(newValue);
                            });
                          },
                          min: 0,
                          max: 1,
                          divisions: 100,
                          label: 'Intensidad',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _Apagado,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.power_settings_new,
                      size: 36.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePressed(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });

    if (index == 0) {
      // Quedarse en WhitePage
    } else if (index == 1) {
      // Navegar a RGBPage y pasar los valores de color e intensidad actuales
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RGB(
            deviceName: widget.deviceName,
            connection: widget.connection,
            initialColor: currentColor,
            initialIntensity: intensity,
          ),
        ),
      );
    }
  }

  void _sendTemperature(int temperature) {
    try {
      String command = "T$temperature\n";
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;
    } catch (e) {
      print('Error sending temperature: $e');
    }
  }

  void _sendIntensity(double intensity) {
    try {
      String command = "I${(intensity * 100).toInt()}\n";
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;
    } catch (e) {
      print('Error sending intensity: $e');
    }
  }

  void _Apagado() async {
    // Enviar señal al módulo Bluetooth para apagar el LED RGB
    try {
      widget.connection.output.add(Uint8List.fromList("OFF\n".codeUnits));
      await widget.connection.output.allSent;

      // Navegar de regreso a la pantalla "PantallaApagado"
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaApagado(
            deviceName: widget.deviceName,
            connection: widget.connection,
          ),
        ),
      );
    } catch (e) {
      print('Error sending data: $e');
    }
  }
}
