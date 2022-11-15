import 'package:cr_todoapp/src/controller/home_controller.dart';
import 'package:cr_todoapp/src/pages/add_todo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = Get.put(HomeController());
    return GetBuilder<HomeController>(builder: (_) {
      return Scaffold(
        body: SlidingUpPanel(
          minHeight: 450,
          maxHeight: 830,
          footer: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
              color: Colors.blue[300],
              height: 20,
              width: _.completedList.isNotEmpty
                  ? MediaQuery.of(context).size.width *
                      _.completedList.length /
                      (_.completedList.length + _.incompletedList.length)
                  : 0),
          borderRadius: BorderRadius.circular(25),
          panel: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 70,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TabBar(
                          tabs: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                '할 일',
                                style: TextStyle(
                                    fontFamily: 'Gowun',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Text(
                                '완료',
                                style: TextStyle(
                                    fontFamily: 'Gowun',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                          indicator: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.blue[200]!, width: 3),
                            ),
                          ),
                          controller: _.tabController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 700,
                          child: TabBarView(
                            controller: _.tabController,
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: _.incompletedList.isNotEmpty
                                        ? ListView.builder(
                                            itemBuilder: (context, index) {
                                              return inCompletedTodoList(
                                                  _, index);
                                            },
                                            itemCount: _.incompletedList.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                          )
                                        : const Center(
                                            child: Text(
                                              '할일이 없어요.',
                                              style: TextStyle(
                                                fontFamily: 'Gowun',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                    child: _.completedList.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: _.completedList.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              return completedTodoList(
                                                  _, index);
                                            },
                                          )
                                        : const Center(
                                            child: Text(
                                              '완료된 일이 없어요.',
                                              style: TextStyle(
                                                fontFamily: 'Gowun',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                TableCalendar(
                  daysOfWeekHeight: 40,
                  headerStyle: const HeaderStyle(
                    headerPadding: EdgeInsets.only(bottom: 30),
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleTextStyle: TextStyle(
                      fontFamily: 'Gowun',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                      // todayDecoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                      weekendTextStyle: TextStyle(color: Colors.redAccent)),
                  locale: 'ko_kr',
                  focusedDay: _.focusedDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    _.getCompletedList(selectedDay);
                    _.getinCompletedList(selectedDay);
                    _.daySelected(selectedDay);
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_.selectedDay, day);
                  },
                  // eventLoader: (day) => _.getEventForDay(day),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  calendarBuilders: calendarBuilders(_),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[300],
          child: const Icon(
            CupertinoIcons.pen,
            size: 30,
          ),
          onPressed: () {
            Get.to(() => const AddTodoPage());
          },
        ),
      );
    });
  }

  Widget completedTodoList(HomeController _, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: _.completedList.isNotEmpty
                ? _.completedList[index].isCompleted == 'false'
                    ? false
                    : true
                : false,
            onChanged: (v) {
              _.completedList.isNotEmpty
                  ? _.updateInCompleted(index, _.completedList[index].id!)
                  : null;
              _.getTodo();
              Get.snackbar(
                '한일 취소',
                '할 일 리스트에 추가됐어요!',
                snackPosition: SnackPosition.TOP,
                icon: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                duration: const Duration(milliseconds: 1500),
              );
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _.completedList.isNotEmpty
                      ? DateFormat.yMd('ko_kr')
                          .format(
                              DateTime.parse(_.completedList[index].writedDate))
                          .toString()
                      : '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _.completedList.isNotEmpty
                      ? _.completedList[index].title
                      : '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _.completedList.isNotEmpty
                      ? _.completedList[index].content
                      : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(AlertDialog(
                title: const Text('한 일 삭제'),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('한 일을 삭제 하시겠어요?'),
                  ],
                ),
                actions: [
                  InkWell(onTap: () => Get.back(), child: const Text('취소')),
                  InkWell(
                      onTap: () {
                        try {
                          _.deleteTodo(_.completedList[index].id!);
                          _.getTodo();
                          Get.back();
                          Get.snackbar(
                            '한 일 삭제',
                            '한 일을 리스트에서 삭제했어요!',
                            snackPosition: SnackPosition.TOP,
                            icon: const Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                            duration: const Duration(milliseconds: 1500),
                          );
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      },
                      child: const Text('확인'))
                ],
                actionsAlignment: MainAxisAlignment.spaceAround,
                actionsPadding: const EdgeInsets.symmetric(vertical: 20),
              ));
            },
            child: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  Widget inCompletedTodoList(HomeController _, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value:
                _.incompletedList[index].isCompleted == 'false' ? false : true,
            onChanged: (v) {
              _.updateCompleted(index, _.incompletedList[index].id!);
              _.getTodo();
              Get.snackbar(
                '할일 완료',
                '완료 리스트에 추가됐어요!',
                snackPosition: SnackPosition.TOP,
                icon: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                duration: const Duration(milliseconds: 1500),
              );
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMd('ko_kr')
                      .format(
                          DateTime.parse(_.incompletedList[index].writedDate))
                      .toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  _.incompletedList[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _.incompletedList[index].content,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(AlertDialog(
                title: const Text('할 일 삭제'),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('할 일을 삭제 하시겠어요?'),
                  ],
                ),
                actions: [
                  InkWell(onTap: () => Get.back(), child: const Text('취소')),
                  InkWell(
                      onTap: () {
                        try {
                          _.deleteTodo(_.incompletedList[index].id!);
                          _.getTodo();
                          Get.back();
                          Get.snackbar(
                            '할 일 삭제',
                            '할 일을 리스트에서 삭제했어요!',
                            snackPosition: SnackPosition.TOP,
                            icon: const Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                            duration: const Duration(milliseconds: 1500),
                          );
                        } catch (e) {
                          // ignore: avoid_print
                          print(e);
                        }
                      },
                      child: const Text('확인'))
                ],
                actionsAlignment: MainAxisAlignment.spaceAround,
                actionsPadding: const EdgeInsets.symmetric(vertical: 20),
              ));
            },
            child: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }

  CalendarBuilders calendarBuilders(HomeController _) {
    return CalendarBuilders(
      markerBuilder: (context, day, events) {
        // _.getEventForDay(day);
        if (_.todoList
            .where((e) =>
                DateFormat.yMd().format(DateTime.parse(e.writedDate)) ==
                DateFormat.yMd().format(day))
            .toList()
            .isEmpty) {
          return null;
        } else {
          return Positioned(
            bottom: -2,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _.todoList
                          .where((e) =>
                              DateFormat.yMd()
                                      .format(DateTime.parse(e.writedDate)) ==
                                  DateFormat.yMd().format(day) &&
                              e.isCompleted == 'false')
                          .toList()
                          .isEmpty
                      ? Colors.blue[300]
                      : Colors.red[300]),
              child: Text(
                _.todoList
                        .where((e) =>
                            DateFormat.yMd()
                                    .format(DateTime.parse(e.writedDate)) ==
                                DateFormat.yMd().format(day) &&
                            e.isCompleted == 'false')
                        .toList()
                        .isEmpty
                    ? _.todoList
                        .where((e) =>
                            DateFormat.yMd()
                                .format(DateTime.parse(e.writedDate)) ==
                            DateFormat.yMd().format(day))
                        .toList()
                        .length
                        .toString()
                    : _.todoList
                        .where((e) =>
                            DateFormat.yMd()
                                    .format(DateTime.parse(e.writedDate)) ==
                                DateFormat.yMd().format(day) &&
                            e.isCompleted == 'false')
                        .toList()
                        .length
                        .toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gowun',
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
            ),
          );
        }
      },
      todayBuilder: (context, day, focusedDay) => Center(
        child: Container(
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue[50]),
          child: Center(
            child: Text(
              day.day.toString(),
              style: TextStyle(
                fontFamily: 'Gowun',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      selectedBuilder: (context, day, focusedDay) =>
          _.focusedDay.day != _.selectedDay.day
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[100],
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(
                        fontFamily: 'Gowun',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[100], shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(
                          fontFamily: 'Gowun', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
      dowBuilder: (context, day) => Center(
        child: Text(
          DateFormat.E('ko_kr').format(day).toString(),
          style: TextStyle(
            fontFamily: 'Gowun',
            fontWeight: FontWeight.bold,
            color: day.weekday == DateTime.sunday
                ? Colors.redAccent
                : day.weekday == DateTime.saturday
                    ? Colors.blueAccent
                    : Colors.black,
          ),
        ),
      ),
      defaultBuilder: (context, day, focusedDay) => Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
            fontFamily: 'Gowun',
            color: day.weekday == DateTime.sunday
                ? Colors.redAccent
                : day.weekday == DateTime.saturday
                    ? Colors.blueAccent
                    : Colors.black,
          ),
        ),
      ),
      outsideBuilder: (context, day, focusedDay) => Container(
        color: const Color(0xFFFAFAFA),
        child: Center(
            child: Text(
          day.day.toString(),
          style: day.weekday == DateTime.sunday
              ? TextStyle(
                  fontFamily: 'Gowun', color: Colors.redAccent.withOpacity(0.5))
              : day.weekday == DateTime.saturday
                  ? TextStyle(
                      fontFamily: 'Gowun', color: Colors.blue.withOpacity(0.5))
                  : const TextStyle(
                      fontFamily: 'Gowun', color: Color(0xFFAEAEAE)),
        )),
      ),
    );
  }
}
