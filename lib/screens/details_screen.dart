import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_db/screens/widgets/appbar_widget.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  String name;
  String age;
  String phone;
  String image;
  DetailsScreen({
    super.key,
    required this.name,
    required this.age,
    required this.phone,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    File img = File(image);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Student Details',
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 350,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: (const Color.fromARGB(100, 0, 187, 212))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                child: SizedBox.fromSize(
                  child: ClipOval(
                    // ignore: unnecessary_null_comparison
                    child: image != null
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
              const SizedBox(
                height: 25,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 26, color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                age,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                phone,
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
