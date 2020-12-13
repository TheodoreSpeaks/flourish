import 'package:flourish/plant_profile.dart';
import 'package:flutter/material.dart';

class PlantDashboard extends StatelessWidget {
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
                              image: AssetImage('assets/plant.jpg'))),
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
                          data: '86\%',
                          alert: true,
                        ),
                        InfoIcon(label: 'Sunlight', data: '4 hr'),
                        InfoIcon(label: 'Temperature', data: '69°F'),
                        InfoIcon(
                          label: 'Humidity',
                          data: '40\%',
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
                      'Bob',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Bamboo',
                      style:
                          TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text('Refresh',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300))),
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
