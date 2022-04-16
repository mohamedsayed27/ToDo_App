import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/shared/cubit/app_cubit.dart';
import 'package:flutter_todo_app/shared/cubit/app_state.dart';
import '../../components.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (BuildContext context,AppState state) {  },
      builder: (BuildContext context,AppState state) {
        var tasks = AppCubit.get(context).doneTasks;

        return buildConditionalBuilder(tasks: tasks);
      },

    );
  }
}
