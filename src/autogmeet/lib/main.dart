import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key key,
  }) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String host = 'http://35.240.254.219:9999';
  String inputText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('autoGmeet'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: 1000,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
                padding: EdgeInsets.all(19),
                child: FlatButton(
                  color: Colors.green,
                  child: Text(
                    'JOIN',
                    style: TextStyle(fontSize: 39),
                  ),
                  onPressed: showOptions,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 1000,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
                padding: EdgeInsets.all(19),
                child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    'EXIT MEETING',
                    style: TextStyle(fontSize: 39),
                  ),
                  onPressed: exitMeeting,
                ),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter message here',
                ),
                onChanged: (text) {
                  inputText = text;
                  // call message request from here
                },
              )),
          Expanded(
            child: SizedBox(
              width: 1000,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
                padding: EdgeInsets.all(19),
                child: FlatButton(
                  color: Colors.blue,
                  child: Text(
                    'SEND MESSAGE',
                    style: TextStyle(fontSize: 39),
                  ),
                  onPressed: sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOptions() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(
              'Select lec number',
              style: TextStyle(fontSize: 39),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => joinMeeting('0'),
                child: const Text(
                  'first',
                  style: TextStyle(fontSize: 29),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => joinMeeting('1'),
                child: const Text(
                  'Second',
                  style: TextStyle(fontSize: 29),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => joinMeeting('2'),
                child: const Text(
                  'third',
                  style: TextStyle(fontSize: 29),
                ),
              ),
            ],
          );
        });
  }

  Future<void> exitMeeting() async {
    String path = host + "/exit";
    var response;
    try {
      response = await http.get(path);
    } catch (e) {
      print(e);
    }
    print(response.body);
  }

  Future<void> ping() async {
    String path = host + "/";
    var response;
    try {
      response = await http.get(path);
    } catch (e) {
      print(e);
    }
    print(response.body);
  }

  Future<void> joinMeeting(String n) async {
    print(n);
    String path = host + "/join?count=" + n;
    var response;
    try {
      response = await http.get(path);
    } catch (e) {
      print(e);
    }
    print(response.body);
  }

  void sendMessage() async {
    String message = inputText;
    var response;
    String path = host + '/message?text=' + message;
    try {
      response = await http.get(path);
    } catch (e) {}
    print(response.body);
  }
}
