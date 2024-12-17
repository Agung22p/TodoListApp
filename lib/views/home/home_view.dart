
// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/fab.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  // check value of circle Indicator
  dynamic valueOfIndicator(List<Task> task){ 
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // Check Done Tasks
  int checkDoneTasks(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks){
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);
    var baseDelete = BaseWidget.of(context).dataStore.box;


    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(), 
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();

        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));

        return Scaffold(
            backgroundColor: Colors.white,

            /// FAB
            floatingActionButton: const Fab(),

            /// body
            
            body: Container(
              child: _buildHomeBody(textTheme, base, tasks, baseDelete),
            ),
          );
      }
      );
  }

  // Home Widget
  Widget _buildHomeBody(
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
    var baseDelete,
    ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [

          /// Custom App bar
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/background1.png'),
                fit: BoxFit.cover
                ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50, // Set width
                            height: 50, // Set height (square shape)
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/img/logo-bg.png'), // Your image here
                                fit: BoxFit
                                    .cover, // Image will cover the container
                              ),
                            ),
                          ),
                          15.w,
                            Text(
                              "To Do List",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Trash icon
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                
                        baseDelete.isEmpty
                          ? noTaskWarning(context)
                          : deleteAllTask(context);
                      
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.trash,
                              size: 25,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 35),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryGradientColor,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      /// Top Level Task info
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStr.mainTitle,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          3.h,
                          Text(
                            "${checkDoneTasks(tasks)} dari ${tasks.length} tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                          ),
                        ],
                      ),
                  
                      /// space
                      150.w,
                  
                      /// Progres Indicator
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          value: checkDoneTasks(tasks) / valueOfIndicator(tasks),
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation(Color.fromARGB(255, 3, 88, 255)),
                        ),
                      ),
                      
                      
                  
                  
                    ],
                  ),
                ),
              ],
            ),
          ),
          

          /// Tasks
          Expanded(
            child: tasks.isNotEmpty? 
            /// Task list is not empty
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                reverse: true,
                itemCount: tasks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  /// Get single task for showing in list
                  var task = tasks[index];
                  return Dismissible(
                    direction: DismissDirection.horizontal,
                    onDismissed: (_) {
                      base.dataStore.deleteTask(task: task);
                    },
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                        8.w,
                        const Text(
                          AppStr.deleteTask,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ]
                      ),
                    key: Key(task.id),
                    child: TaskWidget(task: task)
                    );
                },
              ),
            ): 
            /// task list is empty
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Lottie animation
                FadeIn(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      lottieURL, 
                      animate: tasks.isNotEmpty ? false : true
                      )
                    ),
                ),
                // sub text
                FadeInUp(
                  from: 30,
                  child: const Text(
                    AppStr.doneAllTask,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


