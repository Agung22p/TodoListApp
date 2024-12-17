import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/hive_data_store.dart';
import 'package:todo_app/models/task.dart';

import 'package:todo_app/views/home/home_view.dart';
import 'package:todo_app/views/home/loading_view.dart';
// import 'package:todo_app/views/tasks/task_view.dart';

Future<void> main() async {
  /// init hive db before run app
  await Hive.initFlutter();

  /// Regiser Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());
  
  /// Open a Box
  var box = await Hive.openBox<Task>(HiveDataStore.boxName);

  /// This is step is not necessary
  /// Delete data from previous day
  box.values.forEach(
    (task) {
      if(task.createdAtTime.day != DateTime.now().day){
        task.delete();
      }
    },
  );

  runApp(BaseWidget(child: const MyApp()));
}

/// The inharited widget provides us with a convenient way to
/// pass data between widgets. While dev an app you'll need some
/// data from your parent's widgets or grand parents widgets or beyond
class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;
  
  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError("Could not find ancestor widget of BaseWidget");
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo Application',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        )
      ),
      // home: const HomeView(),
      home: const LoadingView(),
      routes: {
        '/home': (_) => HomeView()
      },
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}