import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordsScreen extends StatefulWidget
{
  RecordsScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
{
  List<String> recList = ["-", "-", "-", "-", "-"];
  @override
  void initState()
  {
    super.initState();
  }

  Future<void> checkList() async
  {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((truePref)
      {
        recList[0] = truePref.getInt("Rec1").toString();
        recList[1] = truePref.getInt("Rec2").toString();
        recList[2] = truePref.getInt("Rec3").toString();
        recList[3] = truePref.getInt("Rec4").toString();
        recList[4] = truePref.getInt("Rec5").toString();
        for (int i = 0; i < recList.length; i++)
        {
          if (recList[i] == "null")
            {
              recList[i] = "-";
            }
        }
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context)
  {
    checkList();
    return Scaffold
      (
      appBar: AppBar(title: Text('Nokia XPress Remake')),
      body: Container
      (
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
        alignment: Alignment.center,
        child: Column
          (
            children: <Widget>[
              ElevatedButton(onPressed: (){}, child: Text('Твои рекорды')),
              ElevatedButton(onPressed: (){}, child: Text(recList[0])),
              ElevatedButton(onPressed: (){}, child: Text(recList[1])),
              ElevatedButton(onPressed: (){}, child: Text(recList[2])),
              ElevatedButton(onPressed: (){}, child: Text(recList[3])),
              ElevatedButton(onPressed: (){}, child: Text(recList[4])),
            ],
        ),
      ),
    );
  }
}


