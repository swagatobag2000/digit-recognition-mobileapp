import 'package:flutter/material.dart';
import 'package:mnistdigitrecognizer/models/Prediction.dart';
import 'package:mnistdigitrecognizer/utils/Constants.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({Key key, this.predictions}) : super(key: key);

  Widget _numberWidget(int num, Prediction prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: Constants.screenHeight * 0.05,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          '${prediction == null ? '' : prediction.confidence.toStringAsFixed(3)}',
          style: TextStyle(fontSize: Constants.screenHeight * 0.015),
        )
      ],
    );
  }

  Widget _labelAndConfidence(String text, int num, Prediction prediction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$text: ',
          style: TextStyle(
              fontSize: Constants.screenHeight * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          text == "Score"
              ? '${(prediction.confidence * 100).toStringAsFixed(1)}'
              : '$num',
          style: TextStyle(
              fontSize: Constants.screenHeight * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
    predictions?.forEach((prediction) {
      data[prediction.index] = prediction;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(this.predictions);
    Prediction maxPrediction = Prediction();
    if (predictions != null && predictions.isNotEmpty) {
      predictions.sort((a, b) => a.confidence.compareTo(b.confidence));
      maxPrediction = predictions.last;
    }
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [for (var i = 0; i < 5; i++) _numberWidget(i, styles[i])],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (var i = 5; i < 10; i++) _numberWidget(i, styles[i])
            ],
          ),
          if (predictions != null && predictions.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _labelAndConfidence("Result",maxPrediction.index, styles[maxPrediction.index]),
                _labelAndConfidence("Score",maxPrediction.index, styles[maxPrediction.index]),
              ],
            )
        ],
      ),
    );
  }
}
