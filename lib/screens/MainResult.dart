import 'package:flutter/material.dart';
import '../models/Prediction.dart';
import '../utils/Constants.dart';

class MainResult extends StatelessWidget {
  final List<Prediction> predictions;

  const MainResult({Key key, this.predictions}) : super(key: key);

  Widget _label(int num, Prediction prediction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Prediction: ',
          style: TextStyle(
              fontSize: Constants.screenHeight * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          '$num',
          style: TextStyle(
              fontSize: Constants.screenHeight * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
      ],
    );
  }

  Widget _confidence(int num, Prediction prediction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Score: ',
          style: TextStyle(
              fontSize: Constants.screenHeight * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.black),
        ),
        Text(
          '${prediction == null ? '' : (prediction.confidence * 100).toStringAsFixed(1)}',
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
    if(predictions == null){
      return Flexible(child: SizedBox(height: Constants.screenHeight * 0.02));
    }
    else{
      var styles = getPredictionStyles(this.predictions);
      Prediction maxPrediction = Prediction();
      if (predictions.isNotEmpty) {
        predictions.sort((a, b) => a.confidence.compareTo(b.confidence));
        maxPrediction = predictions.last;
      }
      return Flexible(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _label(maxPrediction.index, styles[maxPrediction.index]),
                _confidence(maxPrediction.index, styles[maxPrediction.index]),
              ],
            )
          ],
        ),
      );
    }
  }
}
