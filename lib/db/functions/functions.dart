import 'package:flutter/material.dart';
import 'package:student_db/db/model/data_model.dart';
import 'package:student_db/screens/add_student.dart';
import 'package:student_db/screens/edit_sreen.dart';

void navigateToEditScreen(
  BuildContext context,
  StudentModel student,
  int id,
  String age,
  String phone,
  String name,
  String image,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => StudentEditScreen(
        id: id,
        age: age,
        name: name,
        image: image,
        phone: phone,
      ),
    ),
  );
}

void navigateToAddScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ScreenAddStudent(),
    ),
  );
}
