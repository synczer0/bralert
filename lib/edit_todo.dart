import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global variable
//
int sizeOfPrefs;

class EditTodo extends StatelessWidget {
  final t;
  final d;

  EditTodo(this.t, this.d);

  @override
  Widget build(BuildContext context) {
    TextEditingController title =
        new TextEditingController(text: t == null ? '' : t);
    TextEditingController description =
        new TextEditingController(text: d == null ? '' : d);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (sizeOfPrefs == null) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context, sizeOfPrefs);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: title,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.subject),
                        hintText: 'What is your task plan?',
                        labelText: 'Task Title',
                      ),
                      validator: (String value) {
                        return value.isEmpty ? 'Please, enter title....' : null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: description,
                      maxLines: 19,
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.person),
                        hintText:
                            'Enter your description \nfor the task that is on your mind.',
                        labelText: 'Task Description',
                      ),
                      validator: (String value) {
                        return value.contains(null)
                            ? 'Please enter description...'
                            : null;
                      },
                    ),
                  ),
                ],
              ),
              ControlButton(title, description),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final title;
  final description;

  const ControlButton(this.title, this.description);

  void setPrefs(title, description) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(title, description);
  }

  @override
  Widget build(BuildContext context) {
    Future<int> getTaskAll() async {
      final getCount = await SharedPreferences.getInstance();
      return getCount.getKeys().length;
    }

    Future<String> getTitle(e) async {
      final getTitle = await SharedPreferences.getInstance();
      return getTitle.getString(e);
    }

    return ButtonBar(
      buttonMinWidth: 100,
      buttonHeight: 40,
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(width: 0.5),
                ),
              ),
              foregroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor)),
          onPressed: () async {
            String message = "Successfully changed...";
            bool flag;
            if (title.text == "" && description.text == "") {
              message = "Changed Failed....";
              flag = false;
            } else {
              // setPrefs(title.text, description.text);
              final getPrefs = await SharedPreferences.getInstance();

              var getSize = await getTaskAll();
            }

            final snackBar = SnackBar(
              duration: Duration(seconds: 3),
              content: Text(
                "$message",
              ),
              backgroundColor: flag ? Colors.green : Colors.red,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
