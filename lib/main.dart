import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  List<double> aviator = [];
  List<String> foot = [];

  String aviatorSignal = "WAIT";
  String footSignal = "WAIT";

  void addAviator(double v){
    setState(() {
      aviator.insert(0, v);
      if(aviator.length > 20) aviator.removeLast();
      aviatorSignal = getAviatorSignal();
    });
  }

  String getAviatorSignal(){
    int low = aviator.where((x)=>x<1.5).length;
    if(low>=4) return "🟢 ENTER SAFE";
    return "🔴 HIGH RISK";
  }

  void addFoot(String score){
    setState(() {
      foot.insert(0, score);
      if(foot.length > 20) foot.removeLast();
      footSignal = getFootSignal();
    });
  }

  String getFootSignal(){
    int over = foot.where((s){
      var p = s.split("-");
      return (int.parse(p[0]) + int.parse(p[1])) >= 3;
    }).length;

    if(over>=3) return "🟢 OVER";
    return "🔴 UNDER";
  }

  void inputAviator(){
    TextEditingController c = TextEditingController();
    showDialog(context: context, builder: (_)=>AlertDialog(
      title: Text("Aviator Result"),
      content: TextField(controller: c, keyboardType: TextInputType.number),
      actions: [
        TextButton(onPressed: (){
          addAviator(double.tryParse(c.text)??1);
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    ));
  }

  void inputFoot(){
    TextEditingController c = TextEditingController();
    showDialog(context: context, builder: (_)=>AlertDialog(
      title: Text("Score (2-1)"),
      content: TextField(controller: c),
      actions: [
        TextButton(onPressed: (){
          addFoot(c.text);
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yslahn Bet Pro")),
      body: index==0 ? aviatorUI() : footUI(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i)=>setState(()=>index=i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.flight), label: "Aviator"),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: "Foot"),
        ],
      ),
    );
  }

  Widget aviatorUI(){
    return Column(
      children: [
        Text(aviatorSignal, style: TextStyle(fontSize: 22)),
        ElevatedButton(onPressed: inputAviator, child: Text("Add Result")),
        Expanded(child: ListView(children:
          aviator.map((e)=>Text("${e}x")).toList()
        ))
      ],
    );
  }

  Widget footUI(){
    return Column(
      children: [
        Text(footSignal, style: TextStyle(fontSize: 22)),
        ElevatedButton(onPressed: inputFoot, child: Text("Add Score")),
        Expanded(child: ListView(children:
          foot.map((e)=>Text(e)).toList()
        ))
      ],
    );
  }
}
