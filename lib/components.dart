import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/shared/cubit/app_cubit.dart';
bool isdone = false;
Widget defautltFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChanged,
  Function onTap,
  @required Function validate,
  @required String label,
  @required IconData prefixIcon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    onFieldSubmitted: onSubmit,
    onChanged: onChanged,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
          prefixIcon
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
    ),
    onTap: onTap,

  );
}
Widget buildTaskItem(Map model , context){
  return Dismissible(
    background:const Card(
      color: Colors.red,
    ),
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('${model['time']}'),
            radius: 40.0,
          ),
          const SizedBox(width: 20 ,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}',style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.black ),),
                Text('${model['date']}',style: TextStyle(fontWeight:FontWeight.w300,color: Colors.grey[800] ),),
              ],
            ),
          ),
          const SizedBox(width: 20 ,),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: 'done', id: model['id']);
                // isdone=true;
              },
              icon:/*isdone?Icon(Icons.check_box):*/const Icon(Icons.check_box_outlined) ,
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateData(status: 'archived', id: model['id']);
              },
              icon: const Icon(Icons.archive_outlined)),
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).deleteRecord(id: model['id']);
    },
  );
}
Widget buildConditionalBuilder({@required List<Map> tasks}){
  return ConditionalBuilder(
    condition:tasks.isNotEmpty ,
    builder: (context) => ListView.separated(
      itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Container(
          width: double.infinity,
          color: Colors.grey,
          height: 1,
        ),
      ),
      itemCount:tasks.length, ) ,
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
           Icon(Icons.menu),
           Text("Please enter elements to display them")
        ],
      ),
    ),
  );
}
