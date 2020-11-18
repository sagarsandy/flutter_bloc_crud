import 'package:flutter/material.dart';
import 'package:flutter_bloc_crud/model/user.dart';
import 'package:flutter_bloc_crud/services/bloc_service.dart';
import 'package:flutter_bloc_crud/services/user_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Bloc CRUD'),
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
  List<User> students;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int currentUserId; // Used to determine current updating element for update
  String name;
  int age;
  bool isUpdating;
  final studentBloc = BlocService();

  @override
  void initState() {
    super.initState();
    isUpdating = false;
  }

  // Once the record is saved in DB, we are clearing textfield values
  clearName() {
    nameController.text = '';
    ageController.text = '';
  }

  // Function to validate input form
  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        // Updating a record
        User u = User(name, age);
        setState(() {
          isUpdating = false;
        });
        studentBloc.eventSink.add(UserEvent.update(u, currentUserId));
      } else {
        // Inserting a new record
        User u = User(name, age);
        studentBloc.eventSink.add(UserEvent.add(u));
      }
      clearName();
    }
  }

  // List of students with rows and columns widget
  SingleChildScrollView dataTable(List<User> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Expanded(
              child: Text(
                "NAME",
                textAlign: TextAlign.left,
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                "OPTIONS",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        rows: students
            .map(
              (e) => DataRow(
                cells: [
                  DataCell(
                    Text(e.name + "(" + e.age.toString() + ")"),
                  ),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.mode_edit),
                          onPressed: () {
                            nameController.text = e.name;
                            ageController.text = e.age.toString();
                            setState(() {
                              isUpdating = true;
                              currentUserId = students.indexOf(e);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            currentUserId = students.indexOf(e);
                            studentBloc.eventSink
                                .add(UserEvent.delete(currentUserId));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  // Creating list widget
  list() {
    return Expanded(
      child: StreamBuilder<List<User>>(
        stream: studentBloc.studentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Add some data !!");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  // Input form widget
  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
              validator: (val) => val.length == 0 ? "Enter Name" : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Age",
              ),
              validator: (val) => val.length == 0 ? "Enter Age" : null,
              onSaved: (val) => age = int.parse(val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}
