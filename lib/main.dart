import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Shared Prefences'),
      routes: <String, WidgetBuilder>{
        NextPage.routeName:(context)=> new NextPage(),
      },
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
  var _controller= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              controller:_controller,
            ),
          ),
          new ListTile(
            title: new RaisedButton(
              child: new Text("Next Page"),
              onPressed: (){
                saveName();
              },
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void saveName(){
    String name=_controller.text;
    saveNamePreferences(name).then((bool commited){
      Navigator.of(context).pushNamed(NextPage.routeName);
    });
  }
}



Future<bool> saveNamePreferences(String name)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("name", name);
  return prefs.commit();
}

Future<String> getNamePreferences()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString("name");
  return name;
}

class NextPage extends StatefulWidget{
  static String routeName ="/nextPage";

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage>{
  String _name="";

  void initState(){
    getNamePreferences().then(_updateName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Next Page"),
      ),
      body: new ListTile(
        title: new Text(_name),
      ),
    );
  }

  void _updateName(String name){
    setState(() {
      this._name = name;
    });
  }

}