import 'package:flutter/material.dart';

class white extends StatefulWidget {
  const white({super.key});

  @override
  State<white> createState() => _WhitePageState();
}

class _WhitePageState extends State<white> {
  List<bool> isSelected = [true, false];
  double intensity = 0.5; // Initial value for intensity
  double temperature = 0.5; // Initial value for temperature

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
                              Colors.white, Colors.yellow, temperature),
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
                            });
                          },
                          min: 0,
                          max: 1,
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

  // Método para cambiar a RGB o WHITE
  void _togglePressed(int index) {
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

  // Método para apagar el led
  void _Apagado() {
    Navigator.pushNamed(context, 'apagado');
  }
}
