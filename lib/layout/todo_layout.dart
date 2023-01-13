// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, argument_type_not_assignable_to_error_handler, invalid_return_type_for_catch_error, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var  formKey=GlobalKey<FormState>();

  var titleController = TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController dateController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => AppCubit()..createDataBase() ,
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(context,state){
          if(state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        } ,
        builder:(context,state){
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
            ),
            body:ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState ,
              builder:(context)=> AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
              fallback:(context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomShow) {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                }
                else {
                  titleController.clear();
                  timeController.clear();
                  dateController.clear();

                  scaffoldKey.currentState!.showBottomSheet((context) => Container(
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFromField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'title must be not empty';
                                }
                                return null;
                              },
                              labelText: 'Task Title',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            defaultFromField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Time must be not empty';
                                }
                                return null;
                              },
                              labelText: 'Task Time',
                              prefix: Icons.timer_outlined,
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now() ,
                                ).then((value){
                                  timeController.text=value!.format(context).toString();
                                },);

                              },
                              readOnly: true,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            defaultFromField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must be not empty';
                                }
                                return null;
                              },
                              labelText: 'Task Date',
                              prefix: Icons.calendar_today,
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate:DateTime(DateTime.now().year+2) ,
                                ).then((value){
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              },
                              readOnly: true,
                            ),

                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value){
                   cubit.changeBottomShow(isShow: false);
                  });
                  cubit.changeBottomShow(isShow: true);
                }
              },
              child: Icon(
                cubit.isBottomShow ? Icons.add : Icons.edit,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                 cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archive',
                  ),
                ]),
          );
        }
      ),
    );
  }


}
