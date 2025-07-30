import 'package:hive_flutter/hive_flutter.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String studentClass;

  @HiveField(3)
  final String address;

  StudentModel({
    required this.name,
    required this.age,
    required this.studentClass,
    required this.address,
  });
}

 