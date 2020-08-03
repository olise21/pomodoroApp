import 'dart:math' as math;
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
    theme: ThemeData(
      canvasColor: Colors.blueGrey,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      accentColor: Colors.blueAccent,
      brightness: Brightness.dark,
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController controller;

  String get timeString{
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}: ${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1500));
  }

  @override
  Widget build(BuildContext context){
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(aspectRatio: 1.0, child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: controller, 
                        builder: (BuildContext context, Widget child){
                          return new CustomPaint(
                            painter: TimePainter(
                              animation: controller,
                              backgroundColor: Colors.white,
                              color: themeData.indicatorColor,
                            )
                          );
                        }
                        ),
                    ),
                    Align(
                      alignment: FractionalOffset.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Pomodoro Timer",
                            style: themeData.textTheme.subtitle1,
                          ),
                          AnimatedBuilder(
                            animation: controller, 
                            builder: (BuildContext context, Widget child){
                              return new Text(
                                timeString,
                                style: themeData.textTheme.headline1,
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                      animation: controller, 
                      builder: (BuildContext context, Widget child) {
                        return new Icon(controller.isAnimating
                          ? Icons.pause
                          : Icons.play_arrow
                        );
                      },
                    ),
                    onPressed: (){
                      if(controller.isAnimating)
                        controller.stop();
                        else{
                          controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
                        }
                    },
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}



class TimePainter extends CustomPainter{

  TimePainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }): super(repaint: animation);

  final Animation <double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle. stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width/2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimePainter old){
    return animation.value != old.animation.value ||
      color != old.color ||
      backgroundColor != old.backgroundColor;
  }
}