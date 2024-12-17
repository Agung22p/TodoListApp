import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/tasks/components/date_time_selection.dart';
import 'package:todo_app/views/tasks/components/rep_textfield.dart';
import 'package:todo_app/views/tasks/widget/task_view_app_bar.dart';


class TaskView extends StatefulWidget {
  const TaskView({
  super.key, 
  required this.titleTaskController, 
  required this.descriptionTaskController, 
  required this.task
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  // show Selected Time as String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
    }
  }
  
  // show Selected Date as String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date as DateFormat for init Time
  DateTime showDateAsDateTime(DateTime? date){
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  // if any Task Already Exist return True otherways False
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
      widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }


  // Main function for creating or updating tasks
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    // Update current Task
    if (widget.titleTaskController?.text != null && 
        widget.descriptionTaskController?.text != null) {
          try {
            widget.titleTaskController?.text = title;
            widget.descriptionTaskController?.text = subTitle;

            widget.task!.save();
            Navigator.pop(context);
          } catch (e) {
            // if user update task but entered nothing will show this warning
            updateTaskWarning(context);
          }
    } 
    
    /// Create New Task
    else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title, 
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );
        // adding this new task to DB using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        // Warning
        emptyWarning(context);
      }
    }
  }

  /// Delete Task
  dynamic deleteTask(){
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
      
        /// Appbar
        appBar: const TaskViewAppBar(),
      
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Top SIde Texts
                _buildTopSideTexts(textTheme), 
            
                _buildMainTaskViewActivity(textTheme, context),

                /// Bottom side button
                _buildBottomSideButton()
              ],
            ),
          ),
        ),
      
      ),
    );
  }

  /// Bottom side button
  Widget _buildBottomSideButton() {
    return Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 50),
                child: Row(
                  mainAxisAlignment: isTaskAlreadyExist()
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
                  children: [
                    isTaskAlreadyExist()
                    ? Container()
                    : 
                    /// Delete Current Task Button
                    MaterialButton(
                      onPressed: () {
                        deleteTask();
                        Navigator.pop(context); 
                      },
                      minWidth: 150,
                      height: 50,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                          ),
                          5.w,
                          const Text(
                            AppStr.deleteTask,
                            style: TextStyle(
                              color: AppColors.primaryColor
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Add Task Button
                    MaterialButton(
                      onPressed: () {
                        isTaskAlreadyExistUpdateOtherWiseCreate();
                      },
                      minWidth: isTaskAlreadyExist()
                      ? 400
                      : 150,
                      height: 50,
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        isTaskAlreadyExist()
                        ? AppStr.addTaskString
                        : AppStr.updateTaskString,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  /// Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Label Title
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Title",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),
              ),
          ),
          
          /// Task Title
          RepTextField(
          controller: widget.titleTaskController, 
          onFieldSubmitted: (String inputTitle) {
            title = inputTitle;
          }, 
          onChanged: (String inputTitle) {
            title = inputTitle;
          },),

          15.h,

          // Label Description
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Description",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),

          RepTextField(
          controller: widget.descriptionTaskController,
          isForDescription: true, 
          onFieldSubmitted: (String inputSubTitle) {
            subTitle = inputSubTitle;
          }, 
          onChanged: (String inputSubTitle) {
            subTitle = inputSubTitle;
          },
          ),

          15.h,

          // Label Title
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Time",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SizedBox(
                  height: 280,
                  child: TimePickerWidget(
                    initDateTime: showDateAsDateTime(time),
                    dateFormat: 'HH:mm',
                    onChange: (_, __) {},
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task?.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString, 
            time: showTime(time),
            isTime: true,
          ),

          15.h,

          // Label Title
          const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "Date",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ),

          /// Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030,4,5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    
                  if (widget.task?.createdAtDate == null) {
                    date = dateTime;
                  } else {
                    widget.task!.createdAtDate = dateTime;
                  }
                  });
                },
                );
            },
            title: AppStr.dateString, 
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  /// Top Side Texts
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// divider
                const SizedBox(
                  width: 70,
                  child: Divider(
                    thickness: 2,
                  ),
                ),

                RichText(
                    text: TextSpan(
                        text: isTaskAlreadyExist()
                        ? AppStr.addNewTask
                        : AppStr.updateCurrentTask,
                        style: textTheme.titleLarge,
                        children: const [
                      TextSpan(
                        text: AppStr.taskString,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ])),
                const SizedBox(
                  width: 70,
                  child: Divider(
                    thickness: 2,
                  ),
                )

              ],
            ),
          );
  }
}

