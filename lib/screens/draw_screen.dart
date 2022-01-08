import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/models/prediction.dart';
import 'package:mnistdigitrecognizer/screens/drawing_painter.dart';
import 'package:mnistdigitrecognizer/screens/prediction_widget.dart';
import 'package:mnistdigitrecognizer/services/recognizer.dart';
import 'package:mnistdigitrecognizer/utils/constants.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key key}) : super(key: key);

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<DrawingArea> _points = [];
  final _recognizer = Recognizer();
  List<Prediction> _prediction;
  bool initialize = false;
  final GlobalKey canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    Constants().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Digit Recognizer'),
        actions: [
          IconButton(
              onPressed: () async {
                final picture = Recognizer().pointsToPicture(context, _points);
                Uint8List pngBytes = await Recognizer()
                    .imageToByteListUint8(picture, Constants.mnistImageSize);
                print(pngBytes);
              },
              icon: Icon(Icons.save_rounded)),
          IconButton(
              onPressed: () {
                setState(() {
                  _points.clear();
                  _prediction.clear();
                });
              },
              icon: Icon(Icons.close)),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          RepaintBoundary(
            key: canvasKey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// divider listview
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // itemCount: int.parse(
                    //     '${(height * 0.90 / 50).ceil()}'),
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.black,
                        height: 50.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      );
                    },
                  ),
                  color: Colors.white,
                ),
                _drawCanvasWidget(),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          PredictionWidget(predictions: _prediction),
        ],
      ),

    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.blockSizeHorizontal,
      height: Constants.blockSizeVertical,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: Constants.borderSize * 2),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          if (_localPosition.dx >= 0 &&
              _localPosition.dx <= Constants.blockSizeHorizontal &&
              _localPosition.dy >= 0 &&
              _localPosition.dy <= Constants.blockSizeVertical) {
            setState(() {
              _points.add(
                DrawingArea(
                  point: details.localPosition,
                  areaPaint: Paint()
                    ..strokeCap = StrokeCap.round
                    ..isAntiAlias = true
                    ..color = Colors.lightGreenAccent
                    ..strokeWidth = 15.0,
                ),
              );
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(context, _points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
    });
    print(_prediction.first.label);
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}
