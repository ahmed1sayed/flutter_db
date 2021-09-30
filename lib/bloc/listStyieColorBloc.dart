import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
class ColorBloc extends BlocBase{
  ColorBloc();
  var colorControler= BehaviorSubject<Color>.seeded(Colors.white);
  Stream<Color>get colorStream=>colorControler.stream;
  Sink<Color>get colorSink=>colorControler.sink;
  setColor(Color color){
    colorSink.add(color);

  }
  @override
  void dispose() {
    colorControler.close();
    super.dispose();
  }
}