import 'package:flutter/material.dart';
import 'package:kindlelullaby/homePage.dart';
import 'package:kindlelullaby/models/remaindersModel.dart';

import 'database/databaseHelper.dart';

class AddRemainder extends StatefulWidget {
  @override
  _AddRemainderState createState() => _AddRemainderState();
}

class _AddRemainderState extends State<AddRemainder> {
  DateTime pickedDate;
  TimeOfDay time;
  var primarySelected = 0,
      secondarySelected = 0, isLoading = false;
  String notes;

  var primaryType = {0: 'Music', 1: 'Audible', 2: 'Kindle', 3: 'Prime'};
  var primaryImageMap = {
    0: 'amazonMusic.png', 1: 'amazonAudible.jpg',
    2: 'amazonKindle.jpeg', 3: 'amazonPrime.jpeg'};
  var secondaryType = {
    0: '15 mins', 1: '30 mins', 2: '45 mins', 3: '1 hour', 4: '2 hours',
    5: '2 hours +'
  };

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    pickedDate = DateTime(now.year, now.month, now.day + 1);
    time = TimeOfDay.now();
  }

  Widget dateField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Date ',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),

        Text(
          '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}',
          style: TextStyle(fontSize: 18),
        ),
        GestureDetector(
            onTap: _pickDate,
            child: Icon(Icons.date_range)
        )
      ],
    );
  }

  Widget timeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Time ',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),

        Text(
          '   ${time.hour}:${time.minute}    ',
          style: TextStyle(fontSize: 18),
        ),
        GestureDetector(
            onTap: _pickTime,
            child: Icon(Icons.timer)
        )
      ],
    );
  }

  Widget primaryCard(index) {
    return GestureDetector(
      onTap: () => this.setState(() {primarySelected= index;}),
      child: Card(
        color: index == primarySelected ? Colors.grey : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.13,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/' + primaryImageMap[index]),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                primaryType[index],
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondaryCard(index) {
    return GestureDetector(
      onTap: () => this.setState(() {secondarySelected = index;}),
      child: Card(
        color: index == secondarySelected ? Colors.black12 : null,
        child: Center(
          child: Text(
            secondaryType[index],
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget primarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:  10),
      child: GridView.count(
        childAspectRatio: 1,
        shrinkWrap: true,
        crossAxisCount: 4,
        children: List.generate(4, (index) {
          return primaryCard(index);
        }),
      ),
    );
  }


  Widget secondarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:  10),
      child: GridView.count(
        childAspectRatio: 3,
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(secondaryType.length, (index) {
          return secondaryCard(index);
        }),
      ),
    );
  }

  Widget dateTimeCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0),
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                dateField(),
                SizedBox(height: 20.0,),
                timeField(),
              ],
            ),
          )
      ),
    );
  }

  void _addRemainder() async {
    DateTime date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, time.hour, time.minute);
    Remainder remainder = Remainder(dateTime: date.toString(), selectedApp: primarySelected,
        duration: secondarySelected, notes: notes);
    var dbHelper = DBHelper();
    await dbHelper.save(remainder);
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MyHomePage()
    ));
  }

  void _updateNotes(text) {
    setState(() {
      notes=text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New remainder'),
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('   Pick date & time',
                style: TextStyle(fontSize: 20),),
              ),

              dateTimeCard(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('   Select App & duration',
                  style: TextStyle(fontSize: 20),),
              ),
              SizedBox(height: 10.0),
              this.primarySection(),
              this.secondarySection(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('   Add Notes',
                  style: TextStyle(fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the list of books / music / movie you want to spend time with'
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (text) => _updateNotes(text),
                ),
              ),

              Center(
                child: Container(
                  height: 60.0,
                  padding: EdgeInsets.all(8.0),
                  child: FlatButton(
                    onPressed: _addRemainder,
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      'Add remainder',
                      style: TextStyle(fontSize: 18),

                    ),
                  ),
                ),
              )
            ],
          ),
    )
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedDate,
    );

    if(date != null)
      setState(() {
        pickedDate = date;
      });

  }
  _pickTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: time
    );

    if(t != null)
      setState(() {
        time = t;
      });

  }
}
