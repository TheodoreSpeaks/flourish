import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final Widget edit;
  const ProfileHeader({Key key, this.name, this.username, this.edit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: UpperRoundSemiCircle(),
          child: Container(
            height: 220, // TODO: replace with expanded
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
          ),
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(this.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text('${this.username}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 16,
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/plant.jpg'),
                  ),
                ),
                radius: 60,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UpperRoundSemiCircle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // TODO: magic numbers
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
