import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Screens/login.dart';
import 'package:we_chat/Screens/profile.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    APIs.getselfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (list.isNotEmpty) {
                  // Check if the list is not empty
                  Get.to(
                    Profile(
                      user: APIs.me, // Accessing the first element of the list
                    ),
                  );
                } else {
                  print("list is empty");
                }
              },
              icon: const Icon(
                CupertinoIcons.profile_circled,
                size: 30,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(
                  isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                ),
              ),
            ],
            centerTitle: true,
            title: isSearching
                ? TextFormField(
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "  name , email ...",
                        hintStyle: TextStyle(color: Colors.white)),
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  )
                : const Text(
                    "We chat",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
          ),
          body: StreamBuilder(
            // use when we dont what self data eho login in
            stream: APIs.getAllUsers(),
            // stream: APIs.firestore.collection('user').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: isSearching ? _searchList.length : list.length,
                      padding: const EdgeInsets.all(0.5),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user:
                                isSearching ? _searchList[index] : list[index]);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No Connection found!",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            onPressed: () async {
              const Center(child: CircularProgressIndicator());
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //hide circular indicator
                  Get.back();
                  // hide home
                  Get.back();
                  Get.to(const LoginScreen());
                });
              });
            },
            child: const Icon(
              CupertinoIcons.square_arrow_right_fill,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
// final data = snapshot.data?.docs;
// print(data);

// list.clear();
// if (snapshot.hasData) {
//   final data = snapshot.data?.docs;
//   list.clear(); // Clear the list before populating it again
//   for (var i in data!) {
//     print("data ${jsonEncode(i.data())}");
//     list.add(ChatUser.fromJson(
//         i.data())); // Populate the list with ChatUser objects
//   }
//   print('Data $data');
