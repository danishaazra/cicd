import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FactoryDashboard(),
    );
  }
}

class FactoryDashboard extends StatefulWidget {
  @override
  _FactoryDashboardState createState() => _FactoryDashboardState();
}

class _FactoryDashboardState extends State<FactoryDashboard> {
  static final List<String> factoryNames = ['Factory 1', 'Factory 2', 'Factory 3', 'Factory 4'];
  static final List<IconData> factoryIcons = [Icons.factory, Icons.factory, Icons.factory, Icons.factory];
  int selectedIndex = 0;

  // Sensor readings for each factory
  List<double> sensorReadings = [0, 1549.37, 0, 0];
  List<double> steamPressure = [0, 34.19, 0, 0];
  List<double> steamFlow = [0, 22.82, 0, 0];
  List<double> waterLevel = [0, 55.41, 0, 0];
  List<double> powerFrequency = [0, 50.08, 0, 0];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate to the corresponding page
    switch (index) {
      case 0: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
        break;
      case 2: // Settings
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  SettingsPage(),
        )).then((value) {
          // Handle settings update here
          if (value != null) {
            setState(() {
              sensorReadings[selectedIndex] = value; // Update the sensor reading for the selected factory
            });
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Center(
          child: Text(
            factoryNames[selectedIndex],
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black, // Set icon color to black
            onPressed: () {
              _onItemTapped(1); // Navigate to settings page
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          // Dashboard Widget
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Center(
                        child: Text(
                          '${sensorReadings[selectedIndex]} kW',
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WhiteBox(child: SensorWidget(value: steamPressure[selectedIndex], unit: 'bar', label: 'Steam Pressure')),
                        WhiteBox(child: SensorWidget(value: steamFlow[selectedIndex], unit: 'T/H', label: 'Steam Flow')),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WhiteBox(child: SensorWidget(value: waterLevel[selectedIndex], unit: '%', label: 'Water Level')),
                        WhiteBox(child: SensorWidget(value: powerFrequency[selectedIndex], unit: 'Hz', label: 'Power Frequency')),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        '${DateTime.now().toString()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 140.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int index = 0; index < factoryNames.length; index++)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: FactoryButton(
                          icon: factoryIcons[index],
                          text: factoryNames[index],
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          isSelected: index == selectedIndex,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepPurple,
      ),
    );
  }
}

class SensorWidget extends StatelessWidget {
  final double value;
  final String unit;
  final String label;

  const SensorWidget({Key? key, required this.value,required this.unit, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color getGaugeColor(double value) {
      if (value > 30) {
        return Colors.green;
      } else if (value < 29) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Text label on top
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0,
            color: Colors.grey[500]
          ),
        ),
        SizedBox(height: 3.0),
        // Gauge in the middle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            startAngle: 180,
                            endAngle: 0,
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            showTicks: true,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.3,
                              color: Colors.grey[300],
                              thicknessUnit: GaugeSizeUnit.factor,


                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: value,
                                width: 15,
                                color: getGaugeColor(value),
                                pointerOffset: 0.3,
                                cornerStyle: CornerStyle.bothFlat,
                              ),
                              MarkerPointer(
                                value: value,
                                markerOffset: -12,
                                markerHeight: 10,
                                markerWidth: 10,
                                color: getGaugeColor(value),
                              ),
                            ],
                            annotations:<GaugeAnnotation> [
                              GaugeAnnotation(widget: Text(
                                '$value $unit',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                              positionFactor: 1.0,
                              angle: 90,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height:0),
        // Gauge reading at the bottom
      ],
    );
  }
}



class WhiteBox extends StatelessWidget {
  final Widget child;

  const WhiteBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

class FactoryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onPressed;
  final bool isSelected;

  const FactoryButton({Key? key, required this.text, required this.icon, this.onPressed, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:30.0, horizontal: 45),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 0),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.black,
              size: 25.0,
            ),
            SizedBox(height: 3.0),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 20.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0), // Add padding below the image
              child: Image.network(
                'https://www.upm.edu.my/assets/images23/20170406143426UPM-New_FINAL.jpg',
                width: 200, // Adjust width as needed
                height: 100, // Adjust height as needed
              ),
            ),
            Text(
              'Welcome !',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1), // Add some space between the text and the pink box
            Container(
              height: 350,
              width: 350, // Adjust height and width of the pink box
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Shadow color
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Color.fromARGB(255, 249, 208, 206),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your mobile number to activate your account.',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30), // Add some space between the text and the icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Flag_of_Malaysia.svg/1200px-Flag_of_Malaysia.svg.png',
                              width: 40, // Adjust width as needed
                              height: 40, // Adjust height as needed
                            ),
                            SizedBox(width: 10), // Add some space between the image and the text
                            Text(
                              '+60',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(width: 30), // Add some space between the "+60" and the form box
                        Expanded(
                          child: Container(
                            height: 50, // Adjust height as needed
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Add some space below the form box
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (newValue) {
                            setState(() {
                              _agreeToTerms = newValue!;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                            });
                          },
                          child: Text(
                            'I agree to the terms & conditions',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Add some space below the checkbox
                    Container(
                      width: double.infinity, // Make button take up full width
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ActivationPage()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )),
                        ),
                        child: Text(
                          'Get Activation Code',
                          style: TextStyle(
                            color: Color.fromARGB(255, 106, 62, 113),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40), // Add space below the pink box
            Center( // Center the text horizontally
              child: GestureDetector(
                onTap: () {
                  // Add onTap functionality for the disclaimer and privacy statement
                },
                child: Text(
                  'Disclaimer | Privacy Statement',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the two texts
            Center( // Center the text horizontally
              child: Text(
                'Copyright UPM & Kejuruteraan Minyak Sawit \nCSS Sdn. Bhd.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ActivationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 20.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0), // Add padding below the image
              child: Image.network(
                'https://www.upm.edu.my/assets/images23/20170406143426UPM-New_FINAL.jpg',
                width: 200, // Adjust width as needed
                height: 100, // Adjust height as needed
              ),
            ),
            Text(
              'Welcome !',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1), // Add some space between the text and the white box
            Container(
              height: 350,
              width: 350, // Adjust height and width of the white box
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white, // Change color to white
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the activation code you receive via SMS.',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20), // Add some space between the text and the form box
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // Change color of form box to white
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black), // Add black outline
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'OTP',
                                hintStyle: TextStyle(color: Colors.grey.shade700), // Add grey hint text color
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding as needed
                                border: InputBorder.none, // Remove border
                              ),
                              maxLength: 6, // Limit input to 6 characters
                              keyboardType: TextInputType.number, // Set keyboard type to number
                              textAlign: TextAlign.center, // Center the text
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Add space between the form box and the new content
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive?",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(width: 5), // Add space between the text and the "Tap here" text
                        GestureDetector(
                          onTap: () {
                            // Add functionality for the "Tap here" action
                          },
                          child: Text(
                            'Tap here',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Add space between the "Tap here" and the button
                    Center(
                      child: Container(
                        width: 160, // Adjust button width as needed
                        height: 50, // Adjust button height as needed
                        child: ElevatedButton(
                          onPressed: () {
                            // Add functionality for the activate button
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ActivationSuccessPage()),
                            );
                          },
                          child: Text(
                            'Activate',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40), // Add space below the pink box
            Center( // Center the text horizontally
              child: GestureDetector(
                onTap: () {
                  // Add onTap functionality for the disclaimer and privacy statement
                },
                child: Text(
                  'Disclaimer | Privacy Statement',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Add some space between the two texts
            Center( // Center the text horizontally
              child: Text(
                'Copyright UPM & Kejuruteraan Minyak Sawit \nCSS Sdn. Bhd.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ActivationSuccessPage extends StatefulWidget {
  @override
  _ActivationSuccessPageState createState() => _ActivationSuccessPageState();
}

class _ActivationSuccessPageState extends State<ActivationSuccessPage> {
  Color _outlineColor1 = Colors.white; // Outline color for Factory 1 button
  Color _outlineColor2 = Colors.white; // Outline color for Factory 2 button

  void _onFactory1Pressed() {
    setState(() {
      _outlineColor1 = Colors.blue;
      _outlineColor2 = Colors.white;
    });
    // Add functionality for the first button
  }

  void _onFactory2Pressed() {
    setState(() {
      _outlineColor1 = Colors.white;
      _outlineColor2 = Colors.blue;
    });
    // Add functionality for the second button
  }

  void _onPlusButtonPressed(BuildContext context) {
    // Navigate to the "Invitation" page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvitationPage()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        // Navigate to the previous page
        Navigator.pop(context);
      } else if (index == 1) {
        // Navigate to MyHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FactoryDashboard()),
        );
      } else if (index == 2) {
        // Navigate to the SettingsPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Factory 1',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings action here
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade400, // Set grey color as background
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 340,
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        _buildWhiteBoxWithContactInfo("Danisha", "+60143500061"),
                        SizedBox(height: 10),
                        _buildWhiteBoxWithContactInfo("Azra", "+60143500062"),
                        SizedBox(height: 10),
                        _buildWhiteBoxWithContactInfo("Alin", "+60143500063"),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _onPlusButtonPressed(context);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: () {
                        _onFactory1Pressed();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://t3.ftcdn.net/jpg/01/96/21/26/360_F_196212672_6xpBHPWva1jULOvNM7XMD8cNgYAt4tF0.jpg',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Factory 1',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(color: _outlineColor1)),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                        elevation: MaterialStateProperty.all(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: () {
                        _onFactory2Pressed();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://t3.ftcdn.net/jpg/01/96/21/26/360_F_196212672_6xpBHPWva1jULOvNM7XMD8cNgYAt4tF0.jpg',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Factory 2',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(color: _outlineColor2)),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                        elevation: MaterialStateProperty.all(5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: 0, // Set the index for the "home" icon
        selectedItemColor: Colors.purple.shade800,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildWhiteBoxWithContactInfo(String name, String contactInfo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              contactInfo,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class InvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Factory 2',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            Center(
              child: Text(
                'Invitation',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Invite users',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Owner's Name",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Type here',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Owner's Phone Number",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Flag_of_Malaysia.svg/1200px-Flag_of_Malaysia.svg.png',
                  width: 40,
                  height: 30,
                ),
                SizedBox(width: 10),
                Text(
                  '+60',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 12),
                  primary: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color _outlineColor1 = Colors.transparent; // Outline color for Factory 1 button
  Color _outlineColor2 = Colors.transparent; // Outline color for Factory 2 button

  void _onFactory1Pressed() {
    setState(() {
      _outlineColor1 = Colors.blue;
      _outlineColor2 = Colors.transparent;
    });
    // Add functionality for the first button
  }

  void _onFactory2Pressed() {
    setState(() {
      _outlineColor1 = Colors.transparent;
      _outlineColor2 = Colors.blue;
    });
    // Add functionality for the second button
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        title: Row(
          children: [
            Flexible(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Factory 1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Add your settings action here
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 360,
                  height: 470,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Minimum Threshold',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.info_outline, size: 28), // Adjust the size of the info icon
                            Spacer(),
                            Container(
                              width: 55, // Adjust the width here
                              height: 40, // Adjust the height here
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.purple.shade900, size: 25), // Adjust the size of the pencil icon
                                onPressed: () {
                                  // Handle edit button press
                                },
                              ),
                            ),
                          ],
                        ),

SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [
    Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Steam\nPressure',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    SizedBox(width: 100), // Adding space between the two sections
    Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Steam\nFlow',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
),
SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan teks pada ujung kiri dan kanan
  children: [
    Expanded(
      child: Container(
        width: 140, // Adjust the width of the container
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade700), // Add border
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7, 
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade700), 
                  ),
                ),
                child: Center(
                  child: Text(
                    '29',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, 
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'bar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    SizedBox(width: 20), // Adding space between the two sections
    Expanded(
      child: Container(
        width: 140, // Adjust the width of the container
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade700), // Add border
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7, 
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade700), 
                  ),
                ),
                child: Center(
                  child: Text(
                    '22',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, 
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'T/H',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
SizedBox(height: 20),
Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [
    Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Water\nLevel',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    SizedBox(width: 100), // Adding space between the two sections
    Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Power\nFrequency',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
),
SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan teks pada ujung kiri dan kanan
  children: [
    Expanded(
      child: Container(
        width: 140, // Adjust the width of the container
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade700), // Add border
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7, 
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade700), 
                  ),
                ),
                child: Center(
                  child: Text(
                    '53',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, 
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    '%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    SizedBox(width: 20), // Adding space between the two sections
    Expanded(
      child: Container(
        width: 140, // Adjust the width of the container
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade700), // Add border
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7, 
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade700), 
                  ),
                ),
                child: Center(
                  child: Text(
                    '48',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, 
              child: Container(
                height: double.infinity,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'Hz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 160,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: _onFactory1Pressed,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://t3.ftcdn.net/jpg/01/96/21/26/360_F_196212672_6xpBHPWva1jULOvNM7XMD8cNgYAt4tF0.jpg',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Factory 1',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return BorderSide(color: _outlineColor1, width: 2);
                            }
                            return BorderSide(color: _outlineColor1);
                          },
                        ),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                        elevation: MaterialStateProperty.all(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: _onFactory2Pressed,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://t3.ftcdn.net/jpg/01/96/21/26/360_F_196212672_6xpBHPWva1jULOvNM7XMD8cNgYAt4tF0.jpg',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Factory 2',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return BorderSide(color: _outlineColor2, width: 2);
                            }
                            return BorderSide(color: _outlineColor2);
                          },
                        ),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                        elevation: MaterialStateProperty.all(5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
     bottomNavigationBar: BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: '',
    ),
  ],
  currentIndex: 2, // Set the index for the settings icon
  selectedItemColor: Colors.purple.shade800,
  onTap: (index) {
    if (index == 0) {
      // Navigate to WelcomePage
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => WelcomePage()));
    } else if (index == 1) {
      // Navigate to MyHomePage
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => FactoryDashboard()));
    } else if (index == 2) {
      // Handle settings icon tap
    }
  },
),

    );
  }
}



