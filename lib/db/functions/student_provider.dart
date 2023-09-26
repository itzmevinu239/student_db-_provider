import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:student_db/db/model/data_model.dart';

class StudentProvider extends ChangeNotifier {
  late Box<StudentModel> _studentBox;
  List<StudentModel> _studentList = [];
  List<StudentModel> filteredItems = [];
  StudentProvider() {
    initializeHiveBox();
  }

  Future<void> initializeHiveBox() async {
    _studentBox = await Hive.openBox<StudentModel>('students');
    _studentList = _studentBox.values.toList();
    notifyListeners();
  }

  List<StudentModel> get students => _studentList;

  Future<void> addnewStudent(StudentModel newStudent) async {
    await _studentBox.add(newStudent);
    log(
      _studentBox.values.length.toString(),
    );
    _studentList.add(newStudent);
    notifyListeners();
  }

  Future featchAllStudents() async {
    _studentList.clear();
    _studentList.addAll(_studentBox.values);
  }

  Future<void> updateStudent(int id, StudentModel updatedStudent) async {
    await _studentBox.put(id, updatedStudent);
    int studentIndex = _studentList.indexWhere((s) => s.key == Key);
    if (studentIndex >= -1) {
      _studentList[studentIndex] = updatedStudent;
    }
    notifyListeners();
  }

  Future<void> deleteStudent(StudentModel student) async {
    await student.delete();
    _studentList.removeWhere((element) => element.key == student.key);
    notifyListeners();
  }

  Future<List<StudentModel>> search(String query) async {
    filteredItems = _studentBox.values
        .where((student) =>
            student.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
    return filteredItems;
  }
}
