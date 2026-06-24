import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/folder_model.dart';
import 'models/file_model.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(FolderModelAdapter());
  Hive.registerAdapter(FileModelAdapter());

  await Hive.openBox<FolderModel>('folderBox');
  await Hive.openBox<FileModel>('fileBox');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sunflower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
