import 'package:flutter/material.dart';

class ViewTodo extends StatelessWidget {
  final title;
  final description;
  ViewTodo(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    width: 3,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Text(
                title,
                maxLines: 4,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                width: double.infinity,
                height: 350,
                // margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      width: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                child: Text(
                  description,
                  maxLines: 20,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   width: double.infinity,
            //   child: ButtonBar(
            //     buttonHeight: 40,
            //     buttonMinWidth: 90,
            //     alignment: MainAxisAlignment.end,
            //     children: [
            //       FlatButton(
            //         color: Theme.of(context).primaryColor,
            //         onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => EditTodo(title, description)),
            //           );
            //         },
            //         child: Text('Edit'),
            //       ),
            //       FlatButton(
            //         color: Colors.green,
            //         onPressed: () {},
            //         child: Icon(Icons.check_circle_outline),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
