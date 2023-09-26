import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:student_db/db/functions/image_provider.dart';
import 'package:student_db/db/functions/student_provider.dart';
import 'package:student_db/db/model/data_model.dart';
import 'package:student_db/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(
    StudentModelAdapter(),
  );
  await StudentProvider().initializeHiveBox();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>StudentProvider(),),
      ChangeNotifierProvider(create: (context)=>ImageProviders(),),
    ],
    child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan
        
      ),
      home: const StudentListScreen(),
    ),
    );
  }
}
