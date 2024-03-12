import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';

import '../utils/app_constant.dart';

class MemberScreen extends ConsumerStatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends ConsumerState<MemberScreen> {
  late String _role;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _members();
  }

  _members() async {
    var viewUserData = ref.read(accountProvider);
    viewUserData.getStudents();
    viewUserData.getTeachers();
    viewUserData.getstaff();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {
      var viewData = ref.watch(accountProvider);
      var readData = ref.read(accountProvider);
      _role = viewData.AlluserData.role.toString();
      return Scaffold(
        appBar: AppBar(
          title: const Text("Members"),
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Constants.App_bar_blue,
                    Constants.App_bar_light,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.mirror),
            ),
          ),
        ),
        body: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                TabBar(
                  tabs: _role == "student" || _role == "teacher"
                      ? [
                          const Tab(text: 'Class'),
                          const Tab(
                            text: 'Faculty',
                          ),
                        ]
                      : [
                          const Tab(text: 'Class'),
                          const Tab(
                            text: 'Faculty',
                          ),
                          const Tab(text: 'Staff'),
                        ],
                  // controller: _tabBarController,
                  // indicatorColor: Colors.blue,
                  indicator: const BoxDecoration(
                    color: Colors.white,
                    // border: Border(bottom: BorderSide(width: 1.5, color: Colors.blue))
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontSize: 20),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                      children: _role == "student" || _role == "teacher"
                          ? [
                              _classmates(),
                              _teachers(),
                            ]
                          : [
                              _allStudents(),
                              _allTeachers(),
                              _allStaff(),
                            ]),
                )
              ],
            )),
      );
    });
  }

  Widget _classmates() {
    var viewData = ref.watch(accountProvider);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ref.read(accountProvider).classmates.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.classmates[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewData.classmates[index].fName.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(viewData.classmates[index].rollNumber.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  _role == "student"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }

  Widget _teachers() {
    var viewData = ref.watch(accountProvider);
    print(viewData.teachers.length);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: viewData.teachers.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.teachers[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewData.teachers[index].fName.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(viewData.classmates[index].mobile.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }

  Widget _staff() {
    var viewData = ref.watch(accountProvider);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: viewData.staff.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.staff[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Text(viewData.staff[index].fName.toString(),
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  _role == "student"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }

  Widget _allTeachers() {
    var viewData = ref.watch(accountProvider);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ref.read(accountProvider).allTeachers.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.allTeachers[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewData.allTeachers[index].fName.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(viewData.allTeachers[index].rollNumber.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  _role == "student"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }

  Widget _allStudents() {
    var viewData = ref.watch(accountProvider);
    print(viewData.teachers.length);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: viewData.allStudents.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.allStudents[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewData.allStudents[index].fName.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(viewData.allStudents[index].mobile.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }

  Widget _allStaff() {
    var viewData = ref.watch(accountProvider);
    print(viewData.teachers.length);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: viewData.allStff.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAr,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "${Constants.imageUrl}/${viewData.allStff[index].profile}",
                        )),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFCFCFD0)),
              ),
              Container(
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewData.allStff[index].fName.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(viewData.allStff[index].mobile.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Row(
                children: [
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 30,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
                  _role == "student" || _role == "teacher"
                      ? const SizedBox(
                          width: 5,
                        )
                      : IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                ],
              )
            ],
          );
        });
  }
}
