import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_db/db/functions/functions.dart';
import 'package:student_db/db/functions/student_provider.dart';
import 'package:student_db/screens/details_screen.dart';
import 'package:student_db/screens/widgets/appbar_widget.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.featchAllStudents();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Search',
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          CupertinoSearchTextField(
            onChanged: (value) {
              studentProvider.search(value);
              studentProvider.featchAllStudents();
            },
          ),
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: value.filteredItems.length,
                  itemBuilder: (context, index) {
                    final student = value.filteredItems[index];
                    File studentImageFile = File(student.image);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailsScreen(
                                  name: student.name,
                                  age: student.age as String,
                                  phone: student.phone,
                                  image: student.image);
                            },
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          child: SizedBox.fromSize(
                            child: ClipOval(
                              child: student.image != null
                                  ? Image.file(
                                      studentImageFile,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/1.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          student.age as String,
                          style: const TextStyle(fontSize: 15),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  navigateToEditScreen(
                                      context,
                                      student,
                                      student.id as int,
                                      student.age as String,
                                      student.phone,
                                      student.name,
                                      student.image);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Conferm Delete'),
                                            content: const Text(
                                                'Are you sure you want to delete this student ? '),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  value.deleteStudent(student);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
