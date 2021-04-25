import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  @override
  void initState()
  {
    super.initState();
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      appBar: AppBar(title: Text('Nokia XPress Remake')),
      body: Container
        (
          decoration: BoxDecoration(
            //image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
          ),
          child: Column
            (
              children:
                [
                Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Column(
                    children: <Widget>[
                      ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/game');}, child: Text('Начать новую игру')),
                      ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/game');}, child: Text('Рекорды')),
                      ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/help');}, child: Text('Справка')),
                      ElevatedButton(onPressed: (){launch('https://t.me/Miku_Tyan');}, child: Text('Связь с автором'))
                        ]
                    )
                )
              ],
            )
         ),
      );
  }
}