import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_db/db/functions/image_provider.dart';
import 'package:student_db/db/functions/student_provider.dart';
import 'package:student_db/db/model/data_model.dart';
import 'package:student_db/screens/widgets/appbar_widget.dart';

// ignore: must_be_immutable
class StudentEditScreen extends StatelessWidget {
  final StudentModel? student;
  int id;
  String age;
  String name;
  String phone;
  String image;

  StudentEditScreen({
    super.key,
    this.student,
    required this.id,
    required this.age,
    required this.name,
    required this.image,
    required this.phone,
  });

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // ignore: unused_field
  ImageProvider<Object>? _image;

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _ageController.text = age.toString();
    _phoneController.text = phone;

    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Edit Details',
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildprofileImage(context),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              ElevatedButton(
                onPressed: () {
                  saveEditStudent(context);
                  studentProvider.featchAllStudents();
                  Navigator.pop(context);
                },
                child: const Text('save'),
              ),
              if (student != null)
                ElevatedButton(
                  onPressed: () => deleteStudent(context),
                  child: const Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildprofileImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImage(context);
      },
      child: Consumer<ImageProviders>(
        builder: (context, value, child) {
          return CircleAvatar(
            radius: 50,
            child: SizedBox.fromSize(
              child: ClipOval(
                  child: value.selectedImage != null
                      ? Image.file(
                          File(value.selectedImage!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/1.jpg',
                          fit: BoxFit.cover,
                        )),
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {}
  }

  Future<void> showImage(BuildContext context) async {
    final imagePicker = ImagePicker();
    final imagess = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imagess == null) {
      return;
    }
    // ignore: use_build_context_synchronously
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    imageProvider.setSelectedImage(File(imagess.path));
  }

  void saveEditStudent(BuildContext context) async {
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text);
    final phone = _phoneController.text;

    // ignore: unnecessary_null_comparison
    if (name.isEmpty || age == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields Are required'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final updatedStudent = StudentModel(
      name: name,
      id: student!.key,
      age: age as String,
      phone: phone,
      image: imageProvider.selectedImage!.path,
    );
    studentProvider.updateStudent(id, updatedStudent);
    print('qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq');
  }

  void deleteStudent(BuildContext context) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.deleteStudent(student!);
    Navigator.pop(context);
  }
}
