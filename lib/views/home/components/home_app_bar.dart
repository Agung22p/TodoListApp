import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/constants.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});
  

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>{
  

  @override
  Widget build(BuildContext context) {

    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Image.asset('assets/img/logo-bg.png', width: 75, height: 75,),

                ],
              ),
            ),

            /// Trash icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  base.isEmpty
                    ? noTaskWarning(context)
                    : deleteAllTask(context);
                }, 
                icon: const Icon(
                  CupertinoIcons.trash_fill,
                  size: 30,
                  color: Colors.red,
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}