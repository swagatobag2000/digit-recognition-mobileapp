import 'package:flutter/material.dart';
import '../models/DrawingArea.dart';
import '../models/Prediction.dart';
import '../screens/DrawingPainter.dart';
import '../screens/PredictionWidget.dart';
import '../services/Recognizer.dart';
import '../utils/Constants.dart';

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
        title: Text('Handwritten Digit Recognition'),
        actions: [
          // Cancel Button
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
          SizedBox(height: Constants.screenHeight * 0.02),
          RepaintBoundary(
            key: canvasKey,
            child: _drawCanvasWidget(),
          ),
          SizedBox(height: Constants.screenHeight * 0.02),
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
        border: Border.all(color: Colors.black, width: Constants.borderSize),
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
                    ..color = Colors.redAccent
                    ..strokeWidth = Constants.strokeWidth,
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
    List<dynamic> predictions = await _recognizer.recognize(context, _points);
    setState(() {
      _prediction = predictions.map((json) => Prediction.fromJson(json)).toList();
    });
    print(_prediction.first.label);
  }
}

