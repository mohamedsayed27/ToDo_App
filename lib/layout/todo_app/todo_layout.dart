import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/shared/cubit/app_cubit.dart';
import 'package:flutter_todo_app/shared/cubit/app_state.dart';
import 'package:flutter_todo_app/components.dart';
import 'package:intl/intl.dart';
class TodoLayout extends StatefulWidget {
  @override
  State<TodoLayout> createState() => _TodoLayoutState();
}

class _TodoLayoutState extends State<TodoLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppState>(
        listener: (BuildContext context, AppState state) {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context,AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndx]),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndx],
                fallback: (context) => const Center(child: CircularProgressIndicator()),
          ),
            /*cubit.screens[cubit.currentIndx]*/
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown)
                {
                  if (formKey.currentState.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    titleController.text="";
                    timeController.text="";
                    dateController.text="";
                    //   cubit.getDataFromDatabase(cubit.database).then((value) {
                    //   //Navigator.pop(context);
                    //   cubit.isBottomSheetShown = false;
                    //   cubit.fabIcon = Icons.edit;
                    //   cubit.newTasks=value;
                    //
                    // });

                  }
                } else {
                  scaffoldKey.currentState.showBottomSheet((context) => Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defautltFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'title must not be empty ';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefixIcon: Icons.title,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defautltFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'time must not be empty ';
                              }
                              return null;
                            },
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text =
                                    value.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            label: 'Task Time',
                            prefixIcon: Icons.watch_later_outlined,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defautltFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'date must not be empty ';
                              }
                              return null;
                            },
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2021-12-29'),
                              ).then((value) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value);
                              });
                            },
                            label: 'Task Date',
                            prefixIcon: Icons.date_range_outlined,
                          )
                        ],
                      ),
                    ),
                  )).closed.then((value){
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

                  } );

                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndx,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
