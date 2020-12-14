import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flourish/plant_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BrowseDashboards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> dashboards = [
      PlantDashboard(),
      PlantDashboard(
        assetLocation: 'assets/purple_plant.jpg',
        name: 'Charlie',
        type: 'Purple Heart',
      )
    ];

    return Scaffold(
      body: Swiper(
        itemCount: dashboards.length,
        itemBuilder: (context, index) {
          return dashboards[index];
        },
      ),
    );
  }
}

class PlantData {
  String name;
  String type;

  double moisture, sunlight, temp, humidity;

  PlantData(this.name, this.type) {
    moisture = 0;
    sunlight = 0;
    temp = 0;
    humidity = 0;
  }
}

class PlantDashboard extends StatefulWidget {
  final String name;
  final String type;
  final String assetLocation;
  final String addr;

  const PlantDashboard(
      {Key key,
      this.name = 'Bob',
      this.type = 'Bamboo',
      this.addr = '98:D3:32:10:F7:8B',
      this.assetLocation = 'assets/plant.jpg'})
      : super(key: key);

  @override
  _PlantDashboardState createState() => _PlantDashboardState();
}

class _PlantDashboardState extends State<PlantDashboard> {
  PlantData _data;
  BluetoothConnection connection;
  String stringData = '';

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    initConnection();
    _data = PlantData(
      widget.name,
      widget.type,
    );
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  void initConnection() async {
    try {
      connection = await BluetoothConnection.toAddress(widget.addr);
      print('Connected to the device');
      isConnecting = false;
      // connection.output.close();
      connection.input.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        // connection.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          String withExclam = String.fromCharCodes(data);
          stringData += withExclam.substring(0, withExclam.lastIndexOf('!'));
          print('String data: $stringData');
          print('here?');
          List<double> parsedData = stringData.split(' ').map((e) {
            return double.parse(e);
          }).toList();

          stringData = '';
          if (parsedData.length == 4) {
            setState(() {
              _data.moisture = parsedData[0];
              _data.humidity = parsedData[1];
              _data.temp = parsedData[2];
              _data.sunlight = parsedData[3];
            });
          }
          // connection.finish(); // Closing connection
          // print('Disconnecting by local host');
        } else {
          stringData += String.fromCharCodes(data);
          print('String data: $stringData (incomplete)');
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (exception) {
      print('Cannot connect, exception occured $exception');
    }

    update();
  }

  void update() async {
    if (isConnected) connection.output.add(Uint8List.fromList('a'.codeUnits));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(64)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(widget.assetLocation))),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoIcon(
                          label: 'Moisture',
                          data: '${(_data.moisture * 100).round()}\%',
                          alert: _data.moisture > .8 || _data.moisture < .1,
                        ),
                        InfoIcon(
                          label: 'Sunlight',
                          data: '${_data.sunlight + 4} hr',
                          alert: _data.sunlight < 4,
                        ),
                        InfoIcon(
                          label: 'Temperature',
                          data: '${_data.temp.round()}°F',
                          alert: _data.temp < 40 || _data.temp > 85,
                        ),
                        InfoIcon(
                          label: 'Humidity',
                          data: '${_data.humidity.round()}\%',
                          alert: _data.humidity < .1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.type,
                      style:
                          TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: update,
                            child: Center(
                                child: Text('Refresh',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w300))),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlantProfile(),
                              ));
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 16),
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(64),
                                    bottomRight: Radius.circular(64),
                                  )),
                              child: Center(
                                child: Text(
                                  'Info',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final String data;
  final bool alert;
  const InfoIcon(
      {Key key, @required this.label, this.icon, this.data, this.alert = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlantProfile(),
        ));
      },
      child: Container(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                    radius: 36.0,
                    child: Text(
                      data,
                      style: TextStyle(fontSize: 22),
                    )),
                Positioned(
                  right: 0,
                  child: alert
                      ? CircleAvatar(
                          backgroundColor: Colors.yellowAccent,
                          radius: 12,
                          child: Text(
                            "!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            Text(this.label)
          ],
        ),
      ),
    );
  }
}
