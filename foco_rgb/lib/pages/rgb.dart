import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:foco_rgb/pages/white.dart';
import 'dart:async'; // Importación de Timer
import 'pantalla-Apagado.dart'; // Importa la pantalla PantallaApagado
import 'dart:typed_data';

class RGB extends StatefulWidget {
  final String deviceName;
  final BluetoothConnection connection;
  final Color initialColor;
  final double initialIntensity;

  const RGB({
    required this.deviceName,
    required this.connection,
    required this.initialColor,
    required this.initialIntensity,
    Key? key,
  }) : super(key: key);

  @override
  State<RGB> createState() => _RGBState();
}

class _RGBState extends State<RGB> {
  List<bool> isSelected = [false, true];
  late Color _currentColor;
  late double _intensity;
  final CircleColorPickerController _controller = CircleColorPickerController();

  Timer? debounceColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _intensity = widget.initialIntensity;
    _controller.color = _currentColor;
  }

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
                onPressed: _TogglePresionado,
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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleColorPicker(
                      controller: _controller,
                      //ini: _currentColor,
                      colorCodeBuilder: (context, color) {
                        return Text(
                          '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                          style: TextStyle(
                            color: _currentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        );
                      },
                      onChanged: (color) {
                        setState(() {
                          _currentColor = color.withOpacity(_intensity);
                        });
                        if (debounceColor?.isActive ?? false)
                          debounceColor?.cancel();
                        debounceColor =
                            Timer(const Duration(milliseconds: 500), () {
                          _sendColor(_currentColor);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 30.0,
                          activeTrackColor: _currentColor,
                          inactiveTrackColor: _currentColor.withOpacity(0.5),
                          thumbColor: _currentColor,
                          overlayColor: _currentColor.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _intensity,
                          onChanged: (value) {
                            setState(() {
                              _intensity = value;
                              _currentColor =
                                  _currentColor.withOpacity(_intensity);
                            });
                            if (debounceColor?.isActive ?? false)
                              debounceColor?.cancel();
                            debounceColor =
                                Timer(const Duration(milliseconds: 500), () {
                              _sendColor(_currentColor);
                            });
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 100,
                          label: "Intensidad: ${(_intensity * 100).round()}%",
                        ),
                      ),
                    ),
                  ],
                ),
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

  void _TogglePresionado(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WhitePage(
            deviceName: widget.deviceName,
            connection: widget.connection,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RGB(
            deviceName: widget.deviceName,
            connection: widget.connection,
            initialColor: _currentColor,
            initialIntensity: _intensity,
          ),
        ),
      );
    }
  }

  void _sendColor(Color color) {
    try {
      int red = (color.red * _intensity).toInt();
      int green = (color.green * _intensity).toInt();
      int blue = (color.blue * _intensity).toInt();
      String command = "C$red,$green,$blue\n";
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;
    } catch (e) {
      print('Error sending color: $e');
    }
  }

  void _sendCommand(String command) {
    try {
      widget.connection.output.add(Uint8List.fromList(command.codeUnits));
      widget.connection.output.allSent;
    } catch (e) {
      print('Error sending command: $e');
    }
  }

  void _Apagado() async {
    // Enviar señal al módulo Bluetooth para apagar el LED RGB
    try {
      _sendCommand("OFF\n");
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
