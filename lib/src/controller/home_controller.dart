import 'package:cr_todoapp/src/db/todo_db.dart';
import 'package:cr_todoapp/src/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DateTime focusedDay = DateTime.now();
  var selectedDay = DateTime.now();
  late TabController tabController;
  final formKey = GlobalKey<FormState>();
  List<Todo> todoList = [];
  List<Todo> completedList = [];
  List<Todo> incompletedList = [];
  String title = '';
  String content = '';

  daySelected(DateTime day) {
    selectedDay = day;
    update();
  }

  // List<Todo> getEventForDay(DateTime day) {
  //   return [];
  // }

  getinCompletedList(DateTime day) {
    incompletedList = todoList
        .where((e) =>
            DateFormat.yMd().format(DateTime.parse(e.writedDate)) ==
                DateFormat.yMd().format(day) &&
            e.isCompleted == 'false')
        .toList();
    update();
  }

  getCompletedList(DateTime day) {
    completedList = todoList
        .where((e) =>
            DateFormat.yMd().format(DateTime.parse(e.writedDate)) ==
                DateFormat.yMd().format(day) &&
            e.isCompleted == 'true')
        .toList();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getTodo();
  }

  saveTitle(String v) {
    title = v;
    update();
  }

  saveContent(String v) {
    content = v;
    update();
  }

  addTodo(Todo todo) async {
    final db = DatabaseHelper.instance;
    await db.addTodo(todo);
  }

  getTodo() async {
    final db = DatabaseHelper.instance;
    todoList = await db.getTodo();
    getCompletedList(selectedDay);
    getinCompletedList(selectedDay);
    update();
  }

  updateTodo(Todo todo, int id) async {
    final db = DatabaseHelper.instance;
    await db.updateTodo(todo, id);
  }

  updateCompleted(int index, int id) {
    updateTodo(
      Todo(
        id: id,
        title: incompletedList[index].title,
        content: incompletedList[index].content,
        isCompleted: 'true',
        writedDate: incompletedList[index].writedDate.toString(),
      ),
      id,
    );
    update();
  }

  updateInCompleted(int index, int id) {
    updateTodo(
      Todo(
        id: id,
        title: completedList[index].title,
        content: completedList[index].content,
        isCompleted: 'false',
        writedDate: completedList[index].writedDate.toString(),
      ),
      id,
    );
    update();
  }

  deleteTodo(int id) async {
    final db = DatabaseHelper.instance;
    await db.deleteTodo(id);
  }
}
