
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];
  bool isBottomShow = false;

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBare());
  }

  void changeBottomShow({
  required bool isShow,
  }){
    isBottomShow=isShow;
    emit(AppChangeBottomSheetState());
  }



  late Database database;

  void createDataBase() {
   openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database is created');
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXt,date TEXT,time TEXT, status TEXT)')
            .then((value) {
          print('table is created');
        }).catchError((er) {
          print('Error when Creating Table ${er.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database is opened');
      },
    ).then((value) {
      database=value;
      emit(AppCreateDatabaseState());
   });
  }

  Future insertToDataBase({
    required String title,
    required String time,
    required String date,
  }) async
  {
     await database.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks (title, date, time, status) VALUES("$title","$date","$time","new")',
      ).then((value) {
        print('$value insert successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      });
    });
  }


   void getDataFromDatabase(database){
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value){
       value.forEach((element) {
         if(element['status']=='new'){
           newTasks.add(element);
         }else if(element['status']=='done'){
           doneTasks.add(element);
         }else{
           archivedTasks.add(element);
         }

       });
       emit(AppGetDatabaseState());
     }).catchError((er) {
       print('Error in Get From Database ${er.toString()}');
     });
  }

  void updateDate({
  required String status,
  required int id,
})
  {
     database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status,id],
    ).then((value){
      getDataFromDatabase(database);
     });

  }

  void deleteData({
  required int id,
}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value){
      getDataFromDatabase(database);

    });
  }

}