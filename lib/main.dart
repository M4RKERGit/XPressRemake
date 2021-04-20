import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Nokia XPress Remake'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counterPos = 0;
  int _counterNeg = 0;
  String path = "/storage/emulated/0/Download";
  String result;
  String _writeToTable = "Ready To Go";
  List<String> listToTable = ["Empty"];
  List<FileSystemEntity> filesList = [];
  List<String> forButtons = ["-", "-", "-", "-"];
  Random rng = new Random();
  AudioPlayer player = new AudioPlayer();
  bool playing = false;
  int nowWished;


  /*Future<String> getList()
  async {
    path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    Directory dir = new Directory(path);
    filesList = dir.listSync();
    createList();
    return "";
  }*/

  String createList()
  {
    Directory dir = new Directory(path);
    filesList = dir.listSync();
    listToTable = [""];
    if (filesList.isEmpty)
    {
      print("pizdec");
      return "";
    }
    listToTable.clear();
    for (int i = 0; i < filesList.length; i++)
    {
      List<String> buf = filesList[i].path.toString().split(".");
      if (buf[buf.length-1] == "mp3")
      {
        listToTable.add(filesList[i].path.toString().split("/")[5]);
      }
    }
    createString();
    return "";
  }

  void createString()
  {
    _writeToTable = "";
    for (int i = 0; i < listToTable.length; i++)
    {
        _writeToTable += listToTable[i];
        _writeToTable += "\n";
    }
  }

  void rngPower()
  {
    List<String> buf = List.from(listToTable);
    for (int i = 0; i < forButtons.length; i++)
    {
      int curRand = rng.nextInt(buf.length);
      forButtons[i] = buf[curRand];
      buf.removeAt(curRand);
    }
  }

  void _refreshBase() async
  {
    createList();
    forButtons = ["-", "-", "-", "-"];
    setState(()
    {
    });
  }

  void _incrementCounter() async
  {
    await player.stop();
    playing = false;
    forButtons = ["-", "-", "-", "-"];
    _counterPos++;
    setState(()
    {
    });
    _startMusic();
  }

  void _decrementCounter() async
  {
    await player.stop();
    playing = false;
    forButtons = ["-", "-", "-", "-"];
    _counterNeg++;
    setState(()
    {
    });
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
    _MyHomePageState().createList();
    super.initState();
  }

  Future<void> _answeredFirst()
  async {
    if (nowWished == 0)
      {
        _incrementCounter();
      }
    else _decrementCounter();
  }

  Future<void> _answeredSecond()
  async {
    if (nowWished == 1)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _answeredThird()
  async {
    if (nowWished == 2)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _answeredFourth()
  async {
    if (nowWished == 3)
    {
      _incrementCounter();
    }
    else _decrementCounter();
  }

  Future<void> _startMusic() async
  {
    if (playing == false)
      {
        AudioPlayer.logEnabled = false;
        rngPower();
        nowWished = rng.nextInt(forButtons.length);
        String curTrackPath = path + "/" + forButtons[nowWished];
        print("FLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOW" + curTrackPath);
        await player.play(curTrackPath, isLocal: true);
        playing = true;
        Timer(Duration(milliseconds: 100), ()
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
            print("Не перемоталось");
          }
        });
      }
    else
      {
        await player.stop();
        playing = false;
      }
    setState(()
    {
    });
  }

  void _changeDir()
  {
    print("prevPath" + path);
    if (path == "/storage/emulated/0/SD_CARD") path = "/storage/emulated/0/Download";
    if (path == "/storage/emulated/0/Download") path = "/storage/emulated/0/SD_CARD";
    createList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(text: "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                ],
              ),
            ),
            Text(
              '$_counterPos' + '/' + '$_counterNeg',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    TextButton(onPressed: _answeredFirst, child: Text(forButtons[0])),
                    TextButton(onPressed: _answeredSecond, child: Text(forButtons[1])),
                    TextButton(onPressed: _answeredThird, child: Text(forButtons[2])),
                    TextButton(onPressed: _answeredFourth, child: Text(forButtons[3])),
                    FloatingActionButton(onPressed: _startMusic, child: Icon(Icons.play_arrow_rounded)),
                    FloatingActionButton(onPressed: _changeDir, child: Icon(Icons.storage))
              ],
            ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshBase,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ),

    );
  }
}