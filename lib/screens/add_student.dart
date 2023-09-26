import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_db/db/functions/student_provider.dart';
import 'package:student_db/db/model/data_model.dart';
import 'package:student_db/screens/widgets/appbar_widget.dart';
import 'package:student_db/db/functions/image_provider.dart';

// ignore: must_be_immutable
class ScreenAddStudent extends StatelessWidget {
  final StudentModel? student;
  ScreenAddStudent({super.key, this.student});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // ignore: unused_field
  ImageProvider<Object>? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add Student',
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showImage(context);
                },
                child: _buildProfileImage(context),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () => _saveStudent(context),
                child: const Text('Save'),
              ),
              if (student != null)
                ElevatedButton(
                  onPressed: () =>_deleteStudent(context),
                  child: const Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showImage(BuildContext context) async {
    final imagePicker = ImagePicker();
    final imagess = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imagess == null) {
      return;
    }
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    imageProvider.setSelectedImage(
      File(imagess.path),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Consumer<ImageProviders>(builder: ((context, value, child) {
      return GestureDetector(
        child: CircleAvatar(
          radius: 50,
          child: SizedBox.fromSize(
            child: ClipOval(
              child: value.selectedImage != null
                  ? Image.file(
                      value.selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.contact_page),
            ),
          ),
        ),
      );
    }));
  }

  void _saveStudent(BuildContext context) async {
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final name = _nameController.text;
    final age = _ageController.text;
    final phone = _phoneController.text;
    if (name.isEmpty || age.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All Fields are required.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final newStudent = StudentModel(
      name: name,
      age: age ,
      id: DateTime.now().microsecondsSinceEpoch,
      phone: phone,
      image: imageProvider.selectedImage!.path,
    );
    studentProvider.addnewStudent(newStudent);
    Navigator.pop(context);
  }

  void _deleteStudent(BuildContext context) {
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.deleteStudent(student!);
    Navigator.pop(context);
  }
}
