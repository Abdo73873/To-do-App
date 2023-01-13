
// ignore_for_file: prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width=double.infinity,
  double radius=10.0,
  Color background=Colors.blue,
  bool isUppercase=true,
  required String text,
  required  Function()  onPressed,
})=> Container(
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radius),
  ),
  child: MaterialButton(
    onPressed:onPressed,
    child:  Text(
      isUppercase? text.toUpperCase():text,
      style:  TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

Widget defaultFromField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  Function? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  required String? Function(String?) validator,
  required String labelText,
  IconData? prefix,
  IconData? suffix,
  Function()? suffixOnPressed,
  bool isPassword=false,
  bool readOnly=false,
})=> TextFormField(
  controller: controller,
  keyboardType: keyboardType,
  onFieldSubmitted: (v){
    onSubmit!(v);
  },
  onChanged: onChange,
  onTap: onTap,
  validator:validator ,
  obscureText: isPassword,
  decoration: InputDecoration(
    labelText: labelText,
    border: OutlineInputBorder(),
    prefixIcon: prefix!=null?Icon(
      prefix,
    ):null,
    suffixIcon:suffix!=null?IconButton(
      icon: Icon(
          suffix
      ),
      onPressed: suffixOnPressed,

    ):null,
  ),
  readOnly: readOnly,
);

Widget buildTaskIcon(context, Map model)=>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed:(direction){
    AppCubit.get(context).deleteData(id: model['id'],);
  },
  child: Padding(

    padding: const EdgeInsets.all(10.0),

    child: Row(
      children: [
        CircleAvatar(
          radius: 42.0,
          backgroundColor: Colors.lightBlue,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 38.0,
            child: Text(
                '${model['time']}',
                    style :TextStyle(
                      fontWeight: FontWeight.bold,
            ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            height: 60.0,
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${model['title']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],

                              ),
                                    maxLines: 1,
                            ),

                            Text(
                              '${model['date']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],

                        ),

                      ),
                      SizedBox(width: 10.0,),
                      IconButton(
                          onPressed: (){
                            AppCubit.get(context).updateDate(status: 'done', id: model['id'],);
                          },

                          icon: Icon(

                            Icons.check_circle,

                            color: Colors.green,

                          )),
                      IconButton(
                          onPressed: (){
                            AppCubit.get(context).updateDate(status: 'archive', id:model['id'],);
                          },
                          icon: Icon(
                            Icons.archive,
                            color: Colors.grey,

                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      ],

    ),

  ),

);

Widget tasksBuilder({
  required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder:(context)=> ListView.builder(
    itemBuilder:(context,index)=> buildTaskIcon(context,tasks[index]),
    itemCount: tasks.length,
  ),
  fallback:(context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,
          color: Colors.grey,
          size: 100.0,
        ),
        Text('No Tasks yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),),
      ],
    ),
  ),
);