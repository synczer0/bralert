import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global variable
int? sizeOfPrefs;

class AddTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController title = new TextEditingController();
    TextEditingController description = new TextEditingController();

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
                      validator: (String? value) {
                        return value!.isEmpty
                            ? 'Please, enter title....'
                            : null;
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
                      validator: (String? value) {
                        return value!.contains('')
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
                MaterialStatePropertyAll(Theme.of(context).primaryColor),
          ),
          onPressed: () {
            title.text = "";
            description.text = "";
          },
          child: Text('Clear', style: TextStyle(color: Colors.white)),
        ),
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
            String message = "Task successfully added";
            bool flag;
            if (title.text == "" && description.text == "") {
              message = "Task was not successfully added...";
              flag = false;
            } else {
              setPrefs(title.text, description.text);
              var getSize = await getTaskAll();
              sizeOfPrefs = getSize;
              flag = true;
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
          child: Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
