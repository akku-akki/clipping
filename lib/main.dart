import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_animated/flutter_toggle_animated.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ToggleController controller;

  @override
  void initState() {
    controller = ToggleController(
        vsync: this, animationDuration: const Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilding parent");
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Clipper"),
      ),
      body: Stack(
        children: [
          Column(
              children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                  .map(
                    (e) => Container(
                      color: Colors.red,
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                  )
                  .toList()),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedDialog(
              controller: controller,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          controller.toggle();
        },
        child: Icon(
          Icons.ac_unit,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final ToggleController controller;

  const AnimatedDialog({Key key, this.controller}) : super(key: key);
  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        print("rebuilding");
        return ClipOval(
          clipper: ProgressCircleClipper(
              currentProgress: widget.controller.currentAnimatingValue),
          child: Container(
              color: Colors.yellow,
              height: 300,
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [1, 2, 3]
                    .map((e) => CircleAvatar(
                          backgroundColor: Colors.black,
                          minRadius: 40,
                          child: FlutterLogo(
                            size: 35,
                          ),
                        ))
                    .toList(),
              )),
        );
      },
    );
  }
}

class ProgressCircleClipper extends CustomClipper<Rect> {
  final double currentProgress;
  ProgressCircleClipper({this.currentProgress});

  @override
  Rect getClip(Size size) {
    //  getting point of origin for our angle
    final pointStart = Offset(size.width, size.height);
    print(  "X-is  $pointStart.dx");
    print("Y-is $pointStart.dy");

    // calculate our angle
    double theta = atan(pointStart.dy / pointStart.dx);
    //  radius
    final topmostEnd = pointStart.dy / sin(theta);
    //calculating radius with animation progress
    final radius = topmostEnd * currentProgress;
    final diameter = 2 * radius;
    return Rect.fromLTWH(
        pointStart.dx - radius, pointStart.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
