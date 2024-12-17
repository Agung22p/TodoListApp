// lottie assets adress
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_str.dart';

String lottieURL = 'assets/lottie/1.json';


// Empty Title or subtitle TextField Warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must fill all fields!',
    corner: 20.0,
    duration: 2000,
    padding: const EdgeInsets.all(20),
    );
}

// Noting entered when try to update currrent task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must edit the task then try to update it!',
    corner: 20.0,
    duration: 5000,
    padding: const EdgeInsets.all(20),
    );
}

// No Task warning dialog for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(context,
  title: AppStr.oopsMsg,
  message: "There is no Task For Delete!\n Try adding some and then try to delete it!",
  buttonText: "Okay",
  onTapDismiss: () {
    Navigator.pop(context);
  },
  panaraDialogType: PanaraDialogType.warning);
}

/// Delete All Task From DB Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message: "Do You really want to delete all tasks? You'll no be able to undo this action!",
    confirmButtonText: "Yes",
    cancelButtonText: "No",
    onTapConfirm: () {
      /// we'll clear all box data using this command later on
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error);
}