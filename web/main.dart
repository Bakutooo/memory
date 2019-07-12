import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

import 'game.dart';

Future<Null> main() async {
  StageOptions options = StageOptions()
    ..backgroundColor = Color.Beige
    ..renderEngine = RenderEngine.WebGL;

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 1280, height: 800, options: options);

  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

	var game = Game(stage);
	game.start();
}
