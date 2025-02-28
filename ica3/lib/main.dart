import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> paths = [];
  String currentEmoji = 'smile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localPosition = renderBox.globalToLocal(details.globalPosition);

            if (paths.isEmpty || paths.last.isEmpty) {
              paths.add([localPosition]);
            } else {
              paths.last.add(localPosition);
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            paths.add([]); // Finish the current path
          });
        },
        child: CustomPaint(
          painter: MyPainter(paths, currentEmoji),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                paths.clear();
              });
            },
            child: Icon(Icons.clear),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('Smile'),
                          onTap: () {
                            setState(() {
                              currentEmoji = 'smile';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Party Face'),
                          onTap: () {
                            setState(() {
                              currentEmoji = 'party';
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('Heart'),
                          onTap: () {
                            setState(() {
                              currentEmoji = 'heart';
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.face),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final String currentEmoji;

  MyPainter(this.paths, this.currentEmoji);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    final heartPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final partyPaint = Paint()
      ..style = PaintingStyle.fill;

    for (final path in paths) {
      for (int i = 0; i < path.length - 1; i++) {
        if (currentEmoji == 'smile') {
          drawSmile(canvas, path[i]);
        } else if (currentEmoji == 'party') {
          drawPartyFace(canvas, path[i], partyPaint);
        } else if (currentEmoji == 'heart') {
          drawHeart(canvas, path[i], heartPaint);
        }
      }
    }
  }

  void drawSmile(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 20, paint); // Face

    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    // Eyes
    canvas.drawCircle(Offset(center.dx - 8, center.dy - 5), 3, paint);
    canvas.drawCircle(Offset(center.dx + 8, center.dy - 5), 3, paint);

    // Mouth
    Path mouthPath = Path();
    mouthPath.moveTo(center.dx - 10, center.dy + 5);
    mouthPath.quadraticBezierTo(center.dx, center.dy + 15, center.dx + 10, center.dy + 5);
    canvas.drawPath(mouthPath, paint);
  }

  void drawPartyFace(Canvas canvas, Offset center, Paint paint) {
    paint.color = Colors.yellow;
    canvas.drawCircle(center, 30, paint);

    paint.color = Colors.red;
    Path hatPath = Path();
    hatPath.moveTo(center.dx - 20, center.dy - 50);
    hatPath.lineTo(center.dx + 20, center.dy - 50);
    hatPath.lineTo(center.dx, center.dy - 80);
    hatPath.close();
    canvas.drawPath(hatPath, paint);

    final random = math.Random();
    for (int i = 0; i < 10; i++) {
      final x = center.dx + random.nextInt(60) - 30;
      final y = center.dy + random.nextInt(60) - 30;
      paint.color = Color.fromRGBO(
          random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  void drawHeart(Canvas canvas, Offset center, Paint paint) {
    Path path = Path();
    path.moveTo(center.dx, center.dy - 20);
    path.cubicTo(
        center.dx + 40, center.dy - 60, center.dx + 70, center.dy - 20, center.dx,
        center.dy + 20);
    path.cubicTo(
        center.dx - 70, center.dy - 20, center.dx - 40, center.dy - 60, center.dx,
        center.dy - 20);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}