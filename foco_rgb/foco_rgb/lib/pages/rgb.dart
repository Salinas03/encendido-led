import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class RGB extends StatefulWidget {
  const RGB({super.key});

  @override
  State<RGB> createState() => _RGBState();
}

class _RGBState extends State<RGB> {
  List<bool> isSelected = [false, true];
  Color _currentColor = Colors.white;
  double _intensity = 1.0;
  final _controller = CircleColorPickerController(
    initialColor: Colors.white,
  );

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
                        setState(() =>
                            _currentColor = color.withOpacity(_intensity));
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

  //Método para cambiar a RGB o WHITE
  void _TogglePresionado(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });

    if (index == 0) {
      Navigator.pushNamed(context, 'white');
    } else if (index == 1) {
      Navigator.pushNamed(context, 'rgb');
    }
  }

  //método para prender apagar led
  void _Apagado() {
    Navigator.pushNamed(context, 'apagado');
  }
}
