import 'dart:io';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:memogame/data/setPairs.dart';
import 'package:memogame/model/Tile.dart';
import 'package:flutter/services.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startGame(nbOfPlayers) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Main(nbOfPlayers: nbOfPlayers)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Expanded(
                    child: Center(
                        child: Text('Choose Number Of Players',
                            style: TextStyle(
                                color: Colors.purple[600],
                                fontSize: 20,
                                fontWeight: FontWeight.bold)))),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...List.generate(
                  4,
                  (index) => Container(
                        child: TextButton(
                            onPressed: () => _startGame(index + 1),
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                foregroundColor: Colors.purple[300],
                                backgroundColor: Colors.blue[300]),
                            child: Text('${index + 1}')),
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ))
            ])
          ]),
        ));
  }
}

@override
class Main extends StatefulWidget {
  Main({super.key, this.nbOfPlayers});
  var nbOfPlayers;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  var isLoading = true;
  late List<int> Points = List<int>.filled(widget.nbOfPlayers + 1, 0);
  var currentplayer=1;
  void endGame(context) {
    var selectedTileIndex = 0;
    var selectedImagePath = '';
    var selectedImages = 0;
    num currentPlayer = 0;
    solved=0;
    pairs=getPairs();
    Navigator.of(context).pop();
    }

  void initState() {
    // TODO: implement initState
    super.initState();

    pairs.shuffle();

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        pairs.forEach((element) {
          element.setIsSelected(false);
        });
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
        body: Container(
            child: Stack(
          children: [
            Container(child:GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100),
              children: List.generate(
                  pairs.length,
                  (index) => Tile(
                        imagePath: pairs[index].imagePath,
                        isSelected: pairs[index].isSelected,
                        parent: this,
                        tileIndex: index,
                      )),
            ),padding:EdgeInsets.all(30.0)),
            ...List.generate(
                widget.nbOfPlayers,
                (index) => Scores(
                      playerNumber: index + 1,
                      points: Points[index],
                    ))
          ],
        ))),onWillPop:(){endGame(context);return Future.value(false);});
  }
}

class Tile extends StatefulWidget {
  String? imagePath;
  bool? isSelected;
  _MainState? parent;
  int tileIndex;
  Tile({this.imagePath, this.isSelected, this.parent, this.tileIndex = -1});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  void endGame(context) {
    var selectedTileIndex = 0;
    var selectedImagePath = '';
    var selectedImages = 0;
    num currentPlayer = 0;
    solved=0;
    widget.parent?.setState(() {
      pairs = getPairs();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Dialog(
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Container(
                      decoration: BoxDecoration(
                        color:Colors.cyan[100],
                        border:Border.all(
                          color:Colors.purple,
                          width:2
                        ),
                          borderRadius:BorderRadius.circular(10)
                      ),

                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('Player 1 WINS',style:TextStyle(color:Colors.purple[300])),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen())),
                                      icon: const Icon(Icons.home)
                                  ,color:Colors.purple)
                                ])
                          ])]))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (pairs[widget.tileIndex].getisRevealed() == false &&
              widget.parent?.isLoading == false &&
              selectedImages < 2) {
            selectedImages++;
            setState(() {
              pairs[widget.tileIndex].setIsSelected(true);
              print(widget.tileIndex);
            });
            if (selectedImagePath == '') {
              selectedImagePath = widget.imagePath ?? "";
              selectedTileIndex = widget.tileIndex;
            } else {
              if (selectedImagePath == widget.imagePath) {
                //success
                print('saha');
                selectedImagePath = "";
                selectedTileIndex = -1;
                pairs[widget.tileIndex].setIsRevealed(true);
                widget.parent?.setState(() {
                  widget.parent?.Points[currentPlayer.toInt()]++;
                });
                solved++;
                if (solved == 3) endGame(context);
                selectedImages = 0;
              } else {
                //fail
                Future.delayed(Duration(seconds: 2), () {
                  selectedImages = 0;
                  setState(() {
                    print('selected $selectedTileIndex');

                    pairs[widget.tileIndex].setIsSelected(false);
                  });
                  widget.parent?.setState(() {
                    pairs[selectedTileIndex].setIsSelected(false);
                  });
                  selectedImagePath = "";
                  selectedTileIndex = -1;
                  currentPlayer =
                      ((currentPlayer + 1) % widget.parent?.widget.nbOfPlayers).toInt();
                  Scores.currentplayer=currentPlayer+1;
                  print('player : ${Scores.currentplayer}');
                });
              }
              ;
            }
            ;
          }
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(pairs[widget.tileIndex].getisSelected()!
                  ? widget.imagePath!
                  : 'assets/UnSelected.jpg'),
            )));
  }
}

class Scores extends StatefulWidget {
  Scores({super.key, this.playerNumber, this.points});
  int? playerNumber;
  int? points;
  static int currentplayer=1;
  @override
  State<Scores> createState() => _ScoresState();
}

class _ScoresState extends State<Scores>   {
  @override


  @override

  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.playerNumber == 1)
          Positioned(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Card(
                      color: Colors.blue[300],
                      child: Center(
                          child: currentPlayer==1? BlinkText('${widget.points}',
                              style: TextStyle(color: Colors.purple[300]),
                          duration: Duration(seconds: 1),
                          endColor:Colors.transparent):Text('${widget.points}',
                              style: TextStyle(color: Colors.purple[300]))))),
              top: 0.0,
              right: 0),
        if (widget.playerNumber == 2)
          Positioned(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Card(
                      color: Colors.blue[300],
                      child: Center(
                          child: currentPlayer==2? BlinkText('${widget.points}',
                              style: TextStyle(color: Colors.purple[300]),
                              duration: Duration(seconds: 1),
                              times:10):
                          Text('${widget.points}',
                              style: TextStyle(color: Colors.purple[600]))))),
              bottom: 0.0,
              left: 0),
        if (widget.playerNumber == 3)
          Positioned(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Card(
                      color: Colors.blue[300],
                      child: Center(
                          child: Text('${widget.points}',
                              style: TextStyle(color: Colors.purple[300]))))),
              top: 0,
              left: 0),
        if (widget.playerNumber == 4)
          Positioned(
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Card(
                      color: Colors.blue[300],
                      child: Center(
                          child: Text('${widget.points}',
                              style: TextStyle(color: Colors.purple[300]))))),
              bottom: 0,
              right: 0),
      ],
        );
  }
}
