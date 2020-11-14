import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GamePage(),
    );
  }
}


class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  List<Bor> borList = [
  ];

  int fraction = 0;

  int refresh = 1000;//刷新毫秒数

  int difficulty = 1;//对应的难度

  int miss = 0;//遗漏

  Timer timer;

  int startFlag = 0;//0 默认，1 是游戏开始 ，2游戏结算画面

  int countDown = 60;

  @override
  void initState() {
    super.initState();
  }

  _start(){
    if(startFlag == 1){
      print("游戏已开始");
      return;
    }
    _reset();
    startFlag = 1;
    timer = Timer.periodic(Duration(milliseconds: refresh), (timer) {
      countDown --;
      if(countDown == 45 || countDown == 30 || countDown == 15){
        difficulty ++;
        print("难度增加");
      }
      if(countDown <= 0){
        _end();
        print("游戏结束");
      }
//      setState(() {
      _refreshBor();
//      });
    });
  }

  _end(){
    startFlag = 2;
    borList = new List();
    timer.cancel();
  }

  _reset(){
    setState(() {
      fraction = 0;
      refresh = 1000;
      difficulty = 1;
      countDown = 60;
      miss = 0;
      startFlag = 0;
    });

  }

  _refreshBor(){

    if(borList.length != 0){
      miss += borList.length;
    }
    Future.sync((){
      borList = new List();
      for(int i = 0;i < difficulty;i++){
        double sizeWidth = MediaQuery.of(context).size.width - 110;
        double x = Random().nextDouble() * sizeWidth;
        double sizeHeight = MediaQuery.of(context).size.height - 180;
        double y = Random().nextDouble() * sizeHeight;
        borList.add(
            Bor(i, true, x, y)
        );
      }
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分数:$fraction 倒计时:$countDown miss:$miss",style: TextStyle(fontSize: 12),),
        actions: [
//          IconButton(icon: Icon(Icons.settings), onPressed: (){
//            _showSettingDialog();
//          }),
          IconButton(icon: Icon(Icons.timer), onPressed: (){
            _start();
          }),
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            _reset();
          }),
//          IconButton(icon: Icon(Icons.title), onPressed: (){
//            setState(() {
//              borList = [new Bor(0, true, 360, 500)];
//
//            });
//          }),
        ],
      ),
      body: Stack(
        children: List.generate(borList.length, (index){

          return _buildBor(borList[index].x,borList[index].y,index);
        }),
      ),
    );
  }

  Widget _buildBor(double x,double y,int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          Future.sync((){
            borList.removeAt(index);
            fraction ++;
          });
        });
      },
      child: Visibility(
        visible: borList[index].isShow,
        child: Container(
          padding: EdgeInsets.all(30),
          child: Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(left: x,top: y),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(90),
            ),
          ),
        ),
      ),
    );
  }

}

class Bor{
  int id = 0;
  bool isShow = true;
  double x = 0.0;
  double y = 0.0;

  Bor(this.id, this.isShow, this.x, this.y);

}
