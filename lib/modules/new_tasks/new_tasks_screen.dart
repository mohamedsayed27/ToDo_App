import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/components.dart';
import 'package:flutter_todo_app/shared/cubit/app_cubit.dart';
import 'package:flutter_todo_app/shared/cubit/app_state.dart';
class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        listener: (BuildContext context,AppState state) {  },
        builder: (BuildContext context,AppState state) {
          var tasks = AppCubit.get(context).newTasks;

          return buildConditionalBuilder(tasks: tasks);
        },

      );
  }
}
