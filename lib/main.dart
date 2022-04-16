import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/shared/bloc_observer.dart';
import 'layout/news_app/news_layout.dart';
import 'layout/todo_app/todo_layout.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewsLayout(),
    );
  }
}
