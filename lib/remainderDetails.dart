import 'package:flutter/material.dart';
import 'package:kindlelullaby/homePage.dart';
import 'package:kindlelullaby/models/remaindersModel.dart';

import 'constants/constants.dart';
import 'database/databaseHelper.dart';

class RemainderDetails extends StatefulWidget {
  Remainder remainder;
  RemainderDetails(this.remainder);
  @override
  _RemainderDetailsState createState() => _RemainderDetailsState();
}

class _RemainderDetailsState extends State<RemainderDetails> {

  void _deleteRemainder() async {
    var dbHelper = DBHelper();
    await dbHelper.delete(this.widget.remainder.id);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => MyHomePage()
    ));
  }

  Widget textContainer(String text) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text == null ? '' : text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Remainder details'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: _deleteRemainder,
                  child: Icon(
                      Icons.delete,
                      size: 28
                  )),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/' + appImageMap[this.widget.remainder.selectedApp]),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  appDetailsMap[this.widget.remainder.selectedApp],
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20.0,
                ),
                
                textContainer('Date :      ' + this.widget.remainder.dateTime.split(' ')[0]),
                SizedBox(height: 10.0,),

                textContainer('Time :      ' + this.widget.remainder.dateTime.split(' ')[1].split('.')[0].substring(0, 5)),
                SizedBox(height: 10.0,),
                textContainer('Duration :      ' + durationMap[this.widget.remainder.duration]),
                SizedBox(height: 10.0,),

                textContainer(this.widget.remainder.notes),
                SizedBox(height: 10.0,),

              ],
            ),
          ),
        ));
  }
}
