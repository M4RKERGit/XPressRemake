import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget
{
  HelpScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
{
  @override
  void initState()
  {
    super.initState();
  }

  double curWidth, curHeight;


  String _text = "Привет!\n\n"
      "Это небольшое приложение - ремейк "
      "старой игры-викторины с телефонов серии "
      "Nokia XPressMusic\n\n"
      "Правила очень просты - для выбора папки "
      "после начала новой игры нажми на значок "
      "с символом списка\n\n"
      "Затем выбери любую папку с твоей музыкой "
      "(поддерживается flac, mp3)\n\n"
      "После выбора папки при нажатии на кнопку "
      "PLAY начнётся игра\n\n"
      "Твоя задача - угадывать название играющей "
      "сейчас песни.\n\n"
      "Правильный ответ приносит тебе 50 баллов, "
      "неправильный - 100\n\n"
      "Один раунд длится ровно минуту, так что поторопись!";


  @override
  Widget build(BuildContext context)
  {
    curWidth = MediaQuery.of(context).size.width;
    curHeight = MediaQuery.of(context).size.height;
    return Scaffold
      (
      appBar: AppBar(title: Text('Справка ' + '$curWidth' + '/' + '$curHeight')),
      body: Container
      (
          decoration: BoxDecoration(
            //image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover),
          ),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column
            (
              children: <Widget>
                [
                  Text('$_text', textAlign: TextAlign.center),
                Image.asset("assets/flutter.png"),
                Image.asset("dart.png"),
                ]
            )
      )
    );
  }
}