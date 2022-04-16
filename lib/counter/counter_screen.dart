import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/counter/cubit/cubit.dart';
import 'package:flutter_todo_app/counter/cubit/states.dart';
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit() ,
      child: BlocConsumer <CounterCubit,CounterStates> (
        listener: (context,CounterStates state){
          if (state is CounterPlusStates)
            {
              print('state is plus ${state.counter}');
            }
          if (state is CounterMinusStates)
          {
            print('state is minus ${state.counter}');
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(title: Text('Counter'),),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: (){
                       CounterCubit.getContext(context).minus();
                      },
                      child: Text("Minus")),
                  SizedBox(width: 8,),
                  Text('${CounterCubit.getContext(context).counter}'),
                  SizedBox(width: 8,),
                  TextButton(
                      onPressed: (){
                        CounterCubit.getContext(context).plus();
                      },
                      child: Text("Plus")),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
