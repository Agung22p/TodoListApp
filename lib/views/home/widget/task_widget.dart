import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/views/tasks/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (ctx) => TaskView(
                titleTaskController: textEditingControllerForTitle,
                descriptionTaskController: textEditingControllerForSubTitle,
                task: widget.task,
              ),
            ));
      },

      // Main Card
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
            color: widget.task.isCompleted
                // AppColors.primaryColor.withOpacity(0.3)
                ? AppColors.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: widget.task.isCompleted 
            ? Border.all(
              width: 0,
              color: const Color.fromARGB(154, 119, 144, 229)
            )
            : Border.all(
              width: .5,
              color: Colors.grey
              ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  offset: const Offset(1, 7),
                  blurRadius: 10)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
          child: ListTile(
            /// Task Title
            title: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 3),
              child: Text(
                textEditingControllerForTitle.text,
                style: TextStyle(
                  fontSize: 25,
                  color: widget.task.isCompleted
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w900,
                  decoration:
                      widget.task.isCompleted ? TextDecoration.lineThrough : null,
                  decorationColor:
                      widget.task.isCompleted ? Colors.white : Colors.black,
                ),
              ),
            ),
          
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Task Description
                Text(
                  textEditingControllerForSubTitle.text,
                  style: TextStyle(
                    color: widget.task.isCompleted
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w300,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor:
                    widget.task.isCompleted ? Colors.white : Colors.black,
                  ),
                ),
          
                /// Date & Time
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      children: [
                        Center(
                          child: Icon(
                            CupertinoIcons.calendar,
                            size: 25,
                            color: widget.task.isCompleted
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
          
                      10.w,
          
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                DateFormat('hh:mm a')
                                    .format(widget.task.createdAtTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.task.isCompleted
                                      ? Colors.white
                                      : Colors.grey,
                                  decoration:
                                      widget.task.isCompleted ? TextDecoration.lineThrough : null,
                                  decorationColor:
                                      widget.task.isCompleted ? Colors.white : Colors.black,
                                )),
                            Text(
                                DateFormat.yMMMEd().format(widget.task.createdAtDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.task.isCompleted
                                      ? Colors.white
                                      : Colors.grey,
                                  decoration:
                                      widget.task.isCompleted ? TextDecoration.lineThrough : null,
                                  decorationColor:
                                      widget.task.isCompleted ? Colors.white : Colors.black,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          
            /// Check Icon
            trailing: GestureDetector(
              onTap: () {
                widget.task.isCompleted = !widget.task.isCompleted;
                widget.task.save();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  color: 
                      Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: .8),
                ),
                child: Icon(
                  Icons.check,
                  color: widget.task.isCompleted
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
