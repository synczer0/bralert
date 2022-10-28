import 'package:bralert/add_todo.dart';
import 'package:bralert/view_todo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          // accentColor: Colors.deepOrange[400],
          // backgroundColor: Colors.red,
          primaryColor: Colors.orange[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: "Bralert",
        home: Bralert(),
      ),
    );

class Bralert extends StatefulWidget {
  @override
  _BralertState createState() => _BralertState();
}

class _BralertState extends State<Bralert> {
  int sizeOfPrefs;
  String setTitle;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessagerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    setState(() {
      initPrefs();
    });

    super.initState();
  }

  Future<int> getTaskAll() async {
    final getCount = await SharedPreferences.getInstance();
    return getCount.getKeys().length;
  }

  Future<String> getTaskTitle(e) async {
    final getTitle = await SharedPreferences.getInstance();
    return getTitle.getKeys().elementAt(e);
  }

  Future<String> getTaskDescription(e) async {
    final getDes = await SharedPreferences.getInstance();

    return getDes.getString(e);
  }

  void initPrefs() async {
    var getSize = await getTaskAll();
    sizeOfPrefs = getSize;
  }

  Future<List> taskTitle() async {
    var getSize = await getTaskAll();
    var getSome;
    List getTitles = new List();

    // sizeOfPrefs = getSize;
    for (var i = 0; i < getSize; i++) {
      getSome = await getTaskTitle(i);
      getTitles.add(getSome);
    }

    return getTitles.reversed.toList();
  }

  Widget textTitle(index) {
    return FutureBuilder(
      future: taskTitle(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data[index]);
          return Text(snapshot.data[index]);
        } else {
          // Return a indicator or alert that the data was empty.
          return Text('No data');
        }
      },
    );
  }

  _removeTodo(index) async {
    final getTitle = await SharedPreferences.getInstance();
    getTitle.remove(index);
    getTitle.reload();
    print('successfully remove');
  }

  Future<void> _showMyDialog(title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to remove this?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                print('No');
              },
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.green),
              ),
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  _removeTodo(title);
                });

                _scaffoldMessagerKey.currentState.showSnackBar(SnackBar(
                  content: Text('Successfully Removed...'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ));
                Navigator.of(context).pop();
                // print('Yes');
              },
            ),
          ],
        );
      },
    );
  }

  Widget createListView(context) {
    return FutureBuilder(
      future: getTaskAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 0.2,
              color: Colors.black,
            ),
            itemCount: snapshot.data,
            itemBuilder: (context, index) {
              return Container(
                child: ListTile(
                  // contentPadding: EdgeInsets.all(2),
                  // shape: BoxShape,
                  leading: Icon(Icons.assignment),
                  trailing: IconButton(
                      splashRadius: 25,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[700],
                      ),
                      onPressed: () {
                        taskTitle().then((value) {
                          print(value[index]);
                          _showMyDialog(value[index]);
                        });
                      }),
                  onTap: () async {
                    // print(x);
                    // DONE: OnTap view the title and details

                    taskTitle().then((value) async {
                      print(value[index]);

                      var getDes = await getTaskDescription(value[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewTodo(value[index], getDes)),
                      );
                    });
                  },
                  title: textTitle(index),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange[700],
              strokeWidth: 3,
              semanticsLabel: '',
              // value: 1,
            ),
          );
        }
      },
    );
  }

  // Refresh the data
  void onRefresh() {
    setState(() {
      initPrefs();
    });
  }

  _navigate(BuildContext context) async {
    // Get the value from other screen
    final getValue = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodo()),
    );
    // print(getValue);
    setState(() {
      sizeOfPrefs = getValue;
      // initPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldMessagerKey,
            appBar: AppBar(
              titleSpacing: 40,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    onRefresh();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _navigate(context);
                  },
                ),
              ],
              title: Text('Bralert'),
            ),
            body: Container(
              child: createListView(context),
            )));
  }
}
