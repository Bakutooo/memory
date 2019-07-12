import 'package:stagexl/stagexl.dart';

class Card {
  String _content;
  bool _hidden;
  Sprite _sprite;

  Card(String content){
    _content = content;
    _hidden = true;
  }

  String getContent(){
    return _content;
  }

  void flip(){
    _hidden = !_hidden;
  }

  bool isHidden(){
    return _hidden;
  }

  Sprite getSprite(){
    return _sprite;
  }

  void setSprite(Sprite sprite){
    _sprite = sprite;
  }
}