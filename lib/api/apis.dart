import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/model/user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage _storage = FirebaseStorage.instance;

  // fot stroing self inofrmation
  static late ChatUser me;

  // get current user
  static User get user => auth.currentUser!;

  // check if the user axist or not
  static Future<bool> userExist() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  // get user user info
  static Future<void> getselfInfo() async {
    return firestore
        .collection('user')
        .doc(user.uid)
        .get()
        .then((user) async => {
              if (user.exists)
                {
                  me = ChatUser.fromJson(user.data()!),
                  // ignore: avoid_print
                  print("my data ${user.data()}")
                }
              else
                {
                  await createUser().then((value) => getselfInfo()),
                }
            });
  }

  // for creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: "hey I am using we chat",
      createdAt: time,
      id: user.uid,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      email: user.email.toString(),
    );

    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // gettting all user
  // get all user except self account
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('user')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //update user info
  static Future<void> updateUserInfo() async {
    await firestore.collection('user').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // upload image on firebase
  static Future<void> updateProfilePicture(File file) async {
    //getting  pic file extension
    final ext = file.path.split('.').last;
    print("the extension is $ext");

    // storage file and reference it path
    final ref = _storage.ref().child('profile_pictures/${user.uid}.$ext');

    // uploading image and get the url
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data tranfer : ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firebase database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('user')
        .doc(user.uid)
        .update({'image': me.image});
  }
}
