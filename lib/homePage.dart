import 'package:flutter/material.dart';
import 'package:kindlelullaby/addRemainder.dart';
import 'package:kindlelullaby/database/databaseHelper.dart';
import 'package:kindlelullaby/models/remaindersModel.dart';
import 'package:kindlelullaby/remainderDetails.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  var dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialRemainders();
  }

  void getInitialRemainders() async {
    dbHelper = DBHelper();
    var results = await dbHelper.getRemainders();
    setState(() {
      remainders = results;
    });
}

  var appDetailsMap = {
    0: 'Amazon Music', 1: 'Amazon Audible', 2: 'Amazon Kindle', 3: 'Amazon Prime'
  };

  dynamic dayData =
      { "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" };

  dynamic monthData =
      { "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" };

  var durationMap = {
    0: '15 mins', 1: '30 mins', 2: '45 mins', 3: '1 hour', 4: '2 hours',
    5: '2 hours +'
  };

  var appImageMap = {
    0: 'amazonMusic.png', 1: 'amazonAudible.jpg',
    2: 'amazonKindle.jpeg', 3: 'amazonPrime.jpeg'
  };

//  List<Remainder> remainders = [
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 0, notes: '',
//               duration: 0),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 1, notes: '',
//         duration: 1),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 3, notes: '',
//        duration: 5),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 2, notes: '',
//         duration: 2),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 1, notes: '',
//        duration: 1),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 0, notes: '',
//        duration: 0),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 1, notes: '',
//        duration: 1),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 1, notes: '',
//        duration: 3),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 0, notes: '',
//         duration: 2),
//    Remainder(dateTime: DateTime.now().toString(), selectedApp: 1, notes: '',
//        duration: 1),
//  ];
  List<Remainder> remainders = [];

  void _addNewRemainder() {
    setState(() {
      _counter++;
    });
  }

  Widget appSection(Remainder item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.13,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
              AssetImage('assets/images/' + appImageMap[item.selectedApp]),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 3.0),
        Text(
          durationMap[item.duration],
          style: TextStyle(fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget _listItem(Remainder item) {
    DateTime date = DateTime.parse(item.dateTime);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.event_note, size: 40,),
              SizedBox(width: 20.0),

              Container(
                width: MediaQuery.of(context).size.width * 0.62,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        monthData[date.month.toString()] + ' ' +
                        date.day.toString() + ', ' +
                        date.year.toString() + ' - ' +
                        date.hour.toString() + ':' +
                        date.minute.toString() + ' ' ,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.start
                    ),
                    SizedBox(height: 3.0),
                    Text(
                        appDetailsMap[item.selectedApp] + ' scheduled',
                        style: TextStyle(
                            fontSize: 16
                        ),
                        textAlign: TextAlign.start
                    ),
                  ],
                ),
              ),

            appSection(item)
            ],
          ),
        ),
      )
    );
  }

//  List<Widget> _getAllRemainders =

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindle\'s lullaby' ),
      ),
      body: Center(
        child: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: remainders.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = remainders[index];

            return GestureDetector(
                onTap:() { Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RemainderDetails(item))
                );},
                child: _listItem(item)
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
          builder: (context) => AddRemainder())
          );
          },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}