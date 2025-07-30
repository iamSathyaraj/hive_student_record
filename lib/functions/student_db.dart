import 'package:hive_flutter/hive_flutter.dart';
import '../models/student_model.dart';

class StudentDB {
  final Box<StudentModel> _box = Hive.box<StudentModel>('students');

  Future<void> addStudent(StudentModel student) async {
    await _box.add(student);
  } 

  Future<List<StudentModel>> getStudents() async {
    return _box.values.toList();
  }

  Future<void> updateStudent(int index, StudentModel student) async {
    await _box.putAt(index, student);
  }

  Future<void> deleteStudent(int index) async {
    await _box.deleteAt(index);
  }

  Future<StudentModel> getStudent(int index) async {
    return _box.getAt(index)!;
  }
}
