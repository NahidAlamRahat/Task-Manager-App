import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tast_manager/widgets/task_item_widget.dart';

import '../data/models/task_model.dart';

/*class BuildTaskListView{

 static Widget buildTaskListView({required List<TaskModel> taskList, required String status}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              return TaskItemWidget(
                color: const Color.fromRGBO(33, 191, 115, 1),
                taskModel:taskList[index],
                status: status,
                showEditButton: true,
              );
            },
          ),
        ),
      ),
    );
  }
}*/



class BuildTaskListView {

  /// Builds the list view of new tasks
  static Widget buildTaskListView({
    required List<TaskModel> taskList,
    required String status,
    Color color = Colors.blue,
    bool showEditButton = true,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8),
    ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics(),
  }) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: ListView.builder(
          shrinkWrap: true,
          physics: scrollPhysics,
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return TaskItemWidget(
              color: color,
              taskModel: taskList[index],
              status: status,
              showEditButton: showEditButton,
            );
          },
        ),
      ),
    );
  }
}
