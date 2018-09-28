import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class GModel extends Model {
    Color _themeColor = Colors.blue;
    Color get themeColor => _themeColor;
    Brightness _brighness = Brightness.dark;
    Brightness get brightness => _brighness;
    int _num = 0;
    int get num =>_num;
    setColor(Color color) {
        _themeColor = color;
        print(_themeColor);
        notifyListeners();
    }
    setNum (int num) {
        _num = num;
    }
    setBrightness(Brightness brightness) {
        _brighness = brightness;
    }
}