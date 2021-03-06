import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';

import '/Additional/Track.dart';
import '/Additional/UtilFuncs.dart';

import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget
{
  GameScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin
{
  int _counterPos = 0, _counterNeg = 0, _score = 0, nowWished, record;
  double timeCounter = 60.0;
  String path = "", result, settingPath, _startButText = "Поехали";
  bool started = false, playing = false, guessed = false, gameStarted = false;
  List<Track> mainList = [];
  List<FileSystemEntity> filesList = [];
  Track eT = new Track("-");
  List<Track> forButtons = [Track("-"), Track("-"), Track("-"), Track("-")];
  Random rng = new Random();
  AudioPlayer player = new AudioPlayer();
  Icon pausePlayIcon = new Icon(Icons.play_arrow_rounded);
  Timer timer;
  Animation<double> animation;
  AnimationController controller;

  Future<String> getList()
  async
  {
    if (!started)
    {
      path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
      started = true;
    }
    createList();
    return "";
  }

  void createList()
  {
    Directory dir = new Directory(path);
    filesList = dir.listSync(recursive: true, followLinks: false);
    for (int i = 0; i < filesList.length; i++)
    {
      if ( !(filesList[i] is File) )
      {
        filesList.removeAt(i);
      }
    }
    mainList.clear();
    for (int i = 0; i < filesList.length; i++)
    {
      List<String> buf = filesList[i].path.toString().split(".");
      if (buf[buf.length-1] == "mp3")
      {
        mainList.add( Track(filesList[i].path.toString()) );
      }
    }
    return;
  }

  void rngPower()
  {
    List<Track> buf = List.from(mainList);
    if (buf.length == 0) return;
    for (int i = 0; i < forButtons.length; i++)
    {
      int curRand = rng.nextInt(buf.length);
      forButtons[i] = (buf[curRand]);
      buf.removeAt(curRand);
    }
  }

  void _incrementCounter() async
  {
    await player.stop();
    playing = false;
    forButtons = [eT, eT, eT, eT];
    _counterPos++;
    _score = (_counterPos * 50) - (_counterNeg * 100);
    setState(()
    {});
    _startMusic();
  }

  void _decrementCounter() async
  {
    await player.stop();
    playing = false;
    forButtons = [eT, eT, eT, eT];
    _counterNeg++;
    _score = (_counterPos * 50) - (_counterNeg * 100);
    setState(()
    {});
    _startMusic();
  }

  Future<void> requestPermission()
  async
  {
    Permission.storage.request();
  }

  @override
  void initState()
  {
    requestPermission();
    getList();
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 300), vsync: this);
    animation = Tween<double>(begin: 0, end: 360).animate(controller)..addListener(() {setState(() {});});
    controller.forward();
  }

  void checkTimeout()
  {
    if (timeCounter <= -0.1) resetGame();
  }

  Future<void> _answeredFirst()
  async {
    if (playing == false && guessed == false) return;
    if (nowWished == 0)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _answeredSecond()
  async {
    if (playing == false && guessed == false) return;
    if (nowWished == 1)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _answeredThird()
  async {
    if (playing == false && guessed == false) return;
    if (nowWished == 2)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _answeredFourth()
  async {
    if (playing == false && guessed == false) return;
    if (nowWished == 3)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _startMusic() async
  {
      AudioPlayer.logEnabled = false;
      rngPower();
      if (forButtons[0].absPath == "-")
      {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        SnackBar snackBar = new SnackBar(content: Text('В этом каталоге нет музыки:('));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      nowWished = rng.nextInt(forButtons.length);
      String curTrackPath = forButtons[nowWished].absPath;
      print("FLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOW" + curTrackPath);
      await player.play(curTrackPath, isLocal: true);
      playing = true;
      Timer(Duration(milliseconds: forButtons[nowWished].seekDelay), ()
      async
      {
        try
        {
          final future = player.getDuration();
          future.then((curDuration)
          {
            int randVal = curDuration;
            print(randVal);
            Duration newDuration = Duration(milliseconds: rng.nextInt(randVal-30000));
            player.seek(newDuration);
          });
        }
        catch(e)
        {
          await player.play(curTrackPath, isLocal: true);
        }
      });
      pausePlayIcon = new Icon(Icons.pause_sharp);
      setState(() {});
  }

  Future<void> _changeDir()
  async {
    resetGame();
    path = await FilePicker.platform.getDirectoryPath();
    if (path == "/" || path == null) path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    SnackBar snackBar = new SnackBar(content: Text('Успешно выбран путь $path'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    getList();
  }

  void _pauseUnpause()
  {
    if (playing)
      {
        player.pause();
        playing = false;
        pausePlayIcon = new Icon(Icons.play_arrow_rounded);
        setState(() {});
      }
    else
      {
        player.resume();
        playing = true;
        pausePlayIcon = new Icon(Icons.pause_sharp);
        setState(() {});
      }
  }

  void _newGame()
  {
    gameStarted = true;
    _startButText = "Рестарт";
    timer = Timer.periodic(Duration(milliseconds: 100), (timer)
    {
      timeCounter -= 0.1;
      checkTimeout();
      setState(() {});
    });
    _startMusic();
    controller.reset();
    controller.forward();
  }

  void resetGame()
  {
    if (!gameStarted)
    {
      _newGame();
      return;
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    SnackBar snackBar = new SnackBar(content: Text('Ты набил $_score очков'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    checkRecords();
    timer.cancel();
    timeCounter = 60.0;
    player.stop();
    gameStarted = false;
    playing = false;
    _startButText = "Поехали";
    forButtons = [eT, eT, eT, eT];
    setState(() {});
  }

  @override
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }

  Future<void> checkRecords()
  async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> recList = [0, 0, 0, 0, 0];
    recList[0] = prefs.getInt("Rec1");
    recList[1] = prefs.getInt("Rec2");
    recList[2] = prefs.getInt("Rec3");
    recList[3] = prefs.getInt("Rec4");
    recList[4] = prefs.getInt("Rec5");
    for (int i = 0; i < recList.length; i++)
      {
        if (recList[i] == null) recList[i] = 0;
      }
    recList = UtilFuncs.putRec(recList, _score);
    prefs.setInt("Rec1", recList[0]);
    prefs.setInt("Rec2", recList[1]);
    prefs.setInt("Rec3", recList[2]);
    prefs.setInt("Rec4", recList[3]);
    prefs.setInt("Rec5", recList[4]);
    _score = 0;
    return;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nokia XPress Remake'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text
              (
              'Очки: $_score',
              style: Theme.of(context).textTheme.headline4,
            ),Text
              (
              'Время: ' + timeCounter.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: <Widget>[
                  ElevatedButton(onPressed: _answeredFirst, child: Text(forButtons[0].naming, textAlign: TextAlign.center)),
                  ElevatedButton(onPressed: _answeredSecond, child: Text(forButtons[1].naming, textAlign: TextAlign.center)),
                  ElevatedButton(onPressed: _answeredThird, child: Text(forButtons[2].naming, textAlign: TextAlign.center)),
                  ElevatedButton(onPressed: _answeredFourth, child: Text(forButtons[3].naming, textAlign: TextAlign.center)),
                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                            child: Stack(
                              children: <Widget>[
                                ElevatedButton(onPressed: _changeDir, child: Icon(Icons.storage)),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Transform.rotate(
                                        angle: animation.value,
                                        child: CircularProgressIndicator(strokeWidth: 50, value: timeCounter/60),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
                                    child: ElevatedButton(onPressed: _pauseUnpause, child: pausePlayIcon)
                                )
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                              child: Column(
                                  children: <Widget>[(ElevatedButton(onPressed: resetGame, child: Text('$_startButText', textAlign: TextAlign.center)))]
                              )
                          )
                      ]
                    )
                  )
                ],
              ),
            ),
          ],
        ),
        ),
    );
  }
}