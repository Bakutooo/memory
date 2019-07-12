import 'dart:math';
import 'dart:async';

import 'package:stagexl/stagexl.dart';

import 'card.dart';

class Game {
  int nbTry = 0;
  List<Card> deck;
  ResourceManager rm;
  Stage stage;
  Card cardSelected1;
  Card cardSelected2;
  TextField score;

  static final int NB_COLUMN = 6; 
  static final List<String> CARD_SET = ["Roi", "Reine", "Valet", "10", "9", "8", "7", "6", "5", "4", "3", "2"];
  static final int NB_ROW = CARD_SET.length / 6 as int;
  final double START_WIDTH = 10;
  final double START_HEIGHT = 10;

  Game(Stage stage){
    score = TextField();
    deck = List();
    this.stage = stage;
    rm = ResourceManager();
    init();
  }

  void init() async{
    await loadRessource();
    nbTry = 0;
    deck = List();
    fillDeck(CARD_SET);
    fillDeck(CARD_SET);
    deck.shuffle();
    settingCards();
  }

  start(){
    displayCards();
    displayIHM();
  }

  displayIHM(){
    score = TextField();
    score.defaultTextFormat = TextFormat('Spicy Rice', 30, Color.Black);
    score.text = "Nombre d'essai(s) : " + nbTry.toString();
    score.x = 20;
    score.y = 760;
    score.width = 500;
    score.wordWrap = true;
    stage.addChild(score);
  }

  displayCards(){
    var deckSprites = deck.map((card) => card.getSprite());
    deckSprites.forEach((card) => stage.addChild(card));
  }

  fillDeck(List<String> values){
    for (var value in values) {
      deck.add(Card(value));
    }
  }

  loadRessource() async {
    for(int i = 2; i <= 10; i++){
      rm.addBitmapData(i.toString(), "images/" + i.toString() + ".png");
    }

    rm.addBitmapData("As", "images/As.png");
    rm.addBitmapData("Roi", "images/Roi.png");
    rm.addBitmapData("Reine", "images/Reine.png");
    rm.addBitmapData("Valet", "images/Valet.png");
    rm.addBitmapData("Hidden", "images/Hidden.png");
    await rm.load();
  }

  settingCards(){
    for (var i = 0; i < deck.length; i++) {
      var cardData = rm.getBitmapData(deck[i].isHidden() ? "Hidden" : deck[i].isHidden());
      var card = Sprite();
      card.addChild(Bitmap(cardData));

      card.x = START_WIDTH + (80*(i % 6));
      card.y = START_HEIGHT + (100 * (i / 6).floor());
      card.mouseCursor = MouseCursor.POINTER;
      deck[i].setSprite(card);
      stage.addChild(card);

      card.pivotX = cardData.width / 2;
      
      card.onMouseClick.listen((MouseEvent e) {
        if(deck[i].isHidden()){
          card.mouseEnabled = false;
          pickCard(deck[i]);
          flipCard(deck[i]);
        }
      });
    }
  }

  flipCard(Card card) {
    card.flip();
    Tween flip;

    flip = stage.juggler.addTween(card.getSprite(), 0.25);
    flip.animate.skewY.by(pi / 2);
    flip.onComplete = () => revealCard(card);
  }

  revealCard(Card card){
    Tween flip;
    var cardData = rm.getBitmapData(card.isHidden() ? "Hidden" : card.getContent());
    card.getSprite().addChild(Bitmap(cardData));
    card.getSprite().skewY = pi * 1.5;

    flip = stage.juggler.addTween(card.getSprite(), 0.25);
    flip.animate.skewY.by(pi / 2);
    flip.onComplete = () => verifyCards();
    
    card.getSprite().mouseEnabled = true;
  }

  pickCard(Card card){
    if(cardSelected1 == null) {
      cardSelected1 = card;
    } else {
      cardSelected2 = card;
    }
  }

  verifyCards() async {
    if(cardSelected1 == null || cardSelected2 == null) return;
    nbTry++;
    score.text = "Nombre d'essai(s) : " + nbTry.toString();
    var temp1 = cardSelected1;
    var temp2 = cardSelected2;
    cardSelected1 = null;
    cardSelected2 = null;
    if(temp1.getContent() != temp2.getContent()){
      await Future.delayed(const Duration(seconds: 1));
      flipCard(temp1);
      flipCard(temp2);
    }
  }
}