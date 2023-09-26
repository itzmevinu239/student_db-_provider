import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_db/db/functions/functions.dart';
import 'package:student_db/db/functions/image_provider.dart';
import 'package:student_db/db/functions/student_provider.dart';
import 'package:student_db/screens/details_screen.dart';
import 'package:student_db/screens/search_screen.dart';
import 'package:student_db/screens/widgets/appbar_widget.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.featchAllStudents();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Home',
        action: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenSearch(),
                  ),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: value.students.length,
              itemBuilder: (context, index) {
                final student = value.students[index];
                File img = File(student.image);
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
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(104, 158, 158, 158),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: SizedBox.fromSize(
                          child: ClipOval(
                            child: student.image.isNotEmpty
                                ? Image.file(
                                    img,
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
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => navigateToEditScreen(
                                context,
                                student,
                                student.key,
                                student.age as String,
                                student.phone,
                                student.name,
                                student.image,
                              ),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                            'Are You sure you want to delete this student?'),
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
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
