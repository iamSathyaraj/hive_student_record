import 'package:flutter/material.dart';
import '../functions/student_db.dart';
import '../models/student_model.dart';

class DetailPage extends StatefulWidget {
  final StudentModel student;
  final int index;

  const DetailPage({required this.student, required this.index, Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final studentDB = StudentDB();

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController classCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.student.name);
    ageCtrl = TextEditingController(text: widget.student.age.toString());
    classCtrl = TextEditingController(text: widget.student.studentClass);
    addressCtrl = TextEditingController(text: widget.student.address);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    classCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  void showEditStudentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
              TextField(
                controller: ageCtrl,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(controller: classCtrl, decoration: InputDecoration(labelText: 'Class')),
              TextField(controller: addressCtrl, decoration: InputDecoration(labelText: 'Address')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty &&
                  ageCtrl.text.isNotEmpty &&
                  classCtrl.text.isNotEmpty &&
                  addressCtrl.text.isNotEmpty) {
                final updatedStudent = StudentModel(
                  name: nameCtrl.text,
                  age: int.tryParse(ageCtrl.text) ?? 0,
                  studentClass: classCtrl.text,
                  address: addressCtrl.text,
                );
                await studentDB.updateStudent(widget.index, updatedStudent);
                Navigator.pop(ctx);
                setState(() {}); 
              }
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: showEditStudentDialog,
            tooltip: "Edit Student",
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await studentDB.deleteStudent(widget.index);
              Navigator.pop(context);
            },
            tooltip: "Delete Student",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 60, child: Icon(Icons.person, size: 60)),
            SizedBox(height: 20),
            Text("Name: ${student.name}", style: TextStyle(fontSize: 18)),
            Text("Age: ${student.age}", style: TextStyle(fontSize: 18)),
            Text("Class: ${student.studentClass}", style: TextStyle(fontSize: 18)),
            Text("Address: ${student.address}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
