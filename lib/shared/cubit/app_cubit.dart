import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/modules/archive_tasks/archived_tasks_screen.dart';
import 'package:flutter_todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_todo_app/shared/cubit/app_state.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndx = 0;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndx = index;
    emit(AppChangeBottomNavBarIndexState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
      await database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) => print('table created'))
          .catchError((onError) {
        print('Error when Create DB');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   void insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
     await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title , date , time , status ) VALUES("$title" , "$date" , "$time" , "new")')
          .then((value) {
        print('$value inserted successfully ');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print('error while inserting new record ${onError.toString()}');
      });
      return null;
    });
  }
  void updateData({
  @required String status,
  @required int id
}) async{
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, '$id'],).then((value) {
          getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
    });
  }
  void deleteRecord({@required int id}){
     database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
       getDataFromDatabase(database);
       emit(AppDeleteDatabaseState());
     });

  }



  void getDataFromDatabase(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element){
         if(element['status'] == 'new') {
           newTasks.add(element);
         } else if(element['status'] == 'done') {
           doneTasks.add(element);
         } else {
           archivedTasks.add(element);
         }
       });

       emit(AppGetDatabaseState());
     });
  }

  void changeBottomSheetState(
      {@required bool isShow, @required IconData icon}) {
    isBottomSheetShown=isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}
