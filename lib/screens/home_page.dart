import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../functions/student_db.dart';
import '../models/student_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<StudentModel> box; 

  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final studentDB = StudentDB(); 
  @override
  void initState() {
    super.initState();
    box = Hive.box<StudentModel>('students');  
  }

  void showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add New Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: ageCtrl, decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
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
                final newStudent = StudentModel(
                  name: nameCtrl.text,
                  age: int.tryParse(ageCtrl.text) ?? 0,
                  studentClass: classCtrl.text,
                  address: addressCtrl.text,
                );
                await studentDB.addStudent(newStudent); 
                Navigator.pop(context);
                nameCtrl.clear();
                ageCtrl.clear();
                classCtrl.clear();
                addressCtrl.clear();
              }
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Students')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),  
        builder: (context, Box<StudentModel> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No students added'));
          }

          final students = box.values.toList();  
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text(student.name),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(student: student, index: index),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: showAddStudentDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
