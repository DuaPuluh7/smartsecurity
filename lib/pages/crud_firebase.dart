import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudDatabase extends StatefulWidget {
  const CrudDatabase({Key? key}) : super(key: key);

  @override
  State<CrudDatabase> createState() => _CrudDatabaseState();
}

class _CrudDatabaseState extends State<CrudDatabase> {
  late String studentName, studentID, studyProgram;
  late double IPK;

  getStudentname(name) {
    this.studentName = name;
  }

  getStudentID(id) {
    this.studentID = id;
  }

  getStudentStudy(study) {
    this.studyProgram = study;
  }

  getStudentIpk(ipk) {
    this.IPK = double.parse(ipk);
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudent").doc(studentName);

    // create map
    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyprogram": studyProgram,
      "IPK": IPK,
    };

    documentReference.set(students).whenComplete(() =>
        print("$studentName created")); // 'setData' should be replaced with 'set'
  }

  // Updated readData to get all documents
  readData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection("MyStudent").get();

    querySnapshot.docs.forEach((doc) {
      print("Name: ${doc["studentName"]}");
      print("Student ID: ${doc["studentID"]}");
      print("Study Program: ${doc["studyprogram"]}");
      print("IPK: ${doc["IPK"]}");
      print("-------------");
    });
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudent").doc(studentName);

    // create map
    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyprogram": studyProgram,
      "IPK": IPK,
    };

    documentReference.update(students).whenComplete(() =>
        print("$studentName updated")); // 'setData' should be replaced with 'set'
  }

  deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudent").doc(studentName);

    documentReference.delete().whenComplete(() =>
        print("$studentName deleted"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CRUD Firebase',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String name) {
                  getStudentname(name);
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Student ID",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String id) {
                  getStudentID(id);
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Study Program ",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String study) {
                  getStudentStudy(study);
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "IPK",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                onChanged: (String ipk) {
                  getStudentIpk(ipk);
                },
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      createData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Create'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      readData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Read'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              // Updated to display data in a simple ListView
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("MyStudent").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var studentData = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text("Name: ${studentData["studentName"]}"),
                            subtitle: Text("Student ID: ${studentData["studentID"]}"),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
