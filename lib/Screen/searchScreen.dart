import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_content_sharing/Screen/HostScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/group_provider.dart';
import '../utils/app_constant.dart';
import 'community.dart';
import 'createGroup.dart';
import 'groupList.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List _searchIndexList = [];

  @override
  void initState() {
    _allGroup();
    super.initState();
  }

  _allGroup() async{
    var viewGroupData = ref.read(groupProvider);
    var allGroup = await ref.read(groupProvider).allGroupList();
  }

  @override
  Widget build(BuildContext context) {
    var viewGroupData = ref.watch(groupProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 40,
                    width: 250,
                    child: TextField(
                      onChanged: (String s) async {
                        if (s == "") {
                          s == "######";
                        }
                        var searchGroupData = await ref
                            .read(groupProvider)
                            .searchGroup(groupName: s);
                        // setState(() {
                        //   _searchIndexList = [];
                        //
                        // });
                      },
                      autofocus: false,
                      cursorColor: Colors.blue,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textInputAction: TextInputAction
                          .search, //Specify the action button on the keyboard
                      decoration: const InputDecoration(
                        //Style of TextField
                        enabledBorder: UnderlineInputBorder(
                            //Default TextField border
                            borderSide: BorderSide(color: Colors.black54)),
                        focusedBorder: UnderlineInputBorder(
                            //Borders when a TextField is in focus
                            borderSide: BorderSide(color: Colors.black54)),
                        hintText:
                            'Search', //Text that is displayed when nothing is entered.
                        hintStyle: TextStyle(
                          //Style of hintText
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          //  viewGroupData.searchedGroup.length != 2
             //   ? 
                ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                viewGroupData.allGroup.toSet().toList().length,
                itemBuilder: ((context, index) {
                  return GroupList(maingroup: false,
                    index: index,
                    id: viewGroupData.allGroup[index].id,
                    title: viewGroupData.allGroup[index].title,
                    body: viewGroupData.allGroup[index].body,
                    image: viewGroupData.allGroup[index].image,
                    branch: viewGroupData.allGroup[index].branch,
                    year: viewGroupData.allGroup[index].year,
                    public: viewGroupData.allGroup[index].public,
                    admin: viewGroupData.allGroup[index].admin,
                  );
                }))
                // : ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount:
                //         viewGroupData.searchedGroup.toSet().toList().length,
                //     itemBuilder: ((context, index) {
                //       return GroupList(maingroup: false,
                //         index: index,
                //         id: viewGroupData.searchedGroup[index].id,
                //         title: viewGroupData.searchedGroup[index].title,
                //         body: viewGroupData.searchedGroup[index].body,
                //         image: viewGroupData.searchedGroup[index].image,
                //         branch: viewGroupData.searchedGroup[index].branch,
                //         year: viewGroupData.searchedGroup[index].year,
                //         public: viewGroupData.myGroupData[index].public,
                //         admin: viewGroupData.searchedGroup[index].admin,
                //       );
                //     })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeDialog(
            btnOkText: "Add",
            btnCancelColor: Colors.blue,
            btnOkColor: Colors.green,
            btnCancelText: "Request",
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            title: 'Add/Request',
            desc:"Add: Create new community as admin\nRequest: If you don't want to create new community, make request and when that group will be available in future you will be notified",
            btnCancelOnPress: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CommunityPage()));
            },
            btnOkOnPress: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CreateGroup()));
            }
          ).show();
        },
        child: const Icon(Icons.group_add_outlined),
      ),
    );
  }
}
