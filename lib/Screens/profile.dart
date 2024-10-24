import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/Screens/login.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/model/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});

  final ChatUser user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Profile"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
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
          icon: const Icon(
            Icons.add_comment_outlined,
          ),
          label: const Text("Logout"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: mq.height * 0.03,
                  ),
                  Stack(
                    children: [
                      //local image picked
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                File(_image!),
                                fit: BoxFit.cover,
                                height: mq.height * .15,
                                width: mq.width * .35,
                              ),
                            )
                          // image from server
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                height: mq.height * .15,
                                width: mq.width * .35,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),

                      Positioned(
                        bottom: 0,
                        right: -18,
                        child: MaterialButton(
                          elevation: 1,
                          color: Colors.white,
                          shape: const CircleBorder(),
                          onPressed: () {
                            _showBottomSheet();
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) {
                      APIs.me.name = val ?? '';
                    },
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                      hintText: "eg . Name",
                      label: const Text(
                        "Name",
                        style: TextStyle(fontSize: 18),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          CupertinoIcons.person_alt,
                          size: 25,
                          color: Colors.deepPurple,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.03,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) {
                      APIs.me.about = val ?? '';
                    },
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "required field",
                    decoration: InputDecoration(
                      hintText: "eg .Felling happy",
                      label: const Text(
                        "About",
                        style: TextStyle(fontSize: 17),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          CupertinoIcons.info_circle_fill,
                          size: 25,
                          color: Colors.deepPurple,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * 0.05,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(mq.width * 0.5, mq.height * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo();

                        print("inside validator");
                        Get.snackbar("Update", "update Data sucessfully");
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.05,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select profile Picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * 0.3, mq.height * 0.15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        print(
                            "image Path ${image.path} -- minimType ${image.mimeType}");
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Get.back();
                      }
                    },
                    child: Image.asset(
                      'images/add_image.png',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        fixedSize: Size(mq.width * 0.3, mq.height * 0.15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        print("image Path ${image.path}");
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!));
                        Get.back();
                      }
                    },
                    child: Image.asset(
                      'images/camera.png',
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
