import 'package:flourish/bar_chart.dart';
import 'package:flourish/line_chart.dart';
import 'package:flourish/profile_shape.dart';
import 'package:flutter/material.dart';

class PlantProfile extends StatefulWidget {
  @override
  _PlantProfileState createState() => _PlantProfileState();
}

class _PlantProfileState extends State<PlantProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            ProfileHeader(
              name: 'Bob',
              username: 'Bamboo',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),
                    color: Colors.lightGreen),
                tabs: [
                  Tab(text: 'Moisture'),
                  Tab(text: 'Sunlight'),
                  Tab(text: 'Temp'),
                  Tab(text: 'Humidity'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        WarnCard(
                          color: Colors.blue[300],
                          text: 'Current Soil Moisture: 94\%',
                          icon: Icons.opacity,
                        ),
                        WarnCard(
                          color: Colors.red[300],
                          text:
                              'Moisture high!\nTry to remove water from the pot',
                          icon: Icons.warning,
                        ),
                        LineChartSample2(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        BarChartSample1(),
                      ],
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("Hi"),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("Hi"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarnCard extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const WarnCard({
    Key key,
    this.color,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
