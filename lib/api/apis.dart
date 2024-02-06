import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:we_chat/model/message.dart';
import 'package:we_chat/model/user.dart';

class APIs {
  static FirebaseStorage _storage = FirebaseStorage.instance;
  // fot stroing self inofrmation
  static late ChatUser me;
  // get current user
  static User get user => auth.currentUser!;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for push notification
  static FirebaseMessaging fmMessanging = FirebaseMessaging.instance;

  // get fireabse messanging toke in flutter
  static Future<void> getFireabaseMessagingToken() async {
    await fmMessanging.requestPermission();
    await fmMessanging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        print("THe token of device $t");
      }
    });
  }

  // update token of user
  static Future<void> updatedToken() async {
    firestore.collection('user').doc(user.uid).update({
      'push_token': me.pushToken,
    });
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
                  await getFireabaseMessagingToken(),
                  print("my data ${user.data()}")
                }
              else
                {
                  await createUser().then((value) => getselfInfo()),
                }
            });
  }

  // check if the user axist or not
  static Future<bool> userExist() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  //call Api for notificatios
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
        }
      };

      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'key=AAAA1qsQv1M:APA91bFCtTaOwUkyFzOX90j9R1Ru8PzpA8lfsGPlh34f2rzXM08vp9Ohc19fx77-4-QjZb8pQWkc471e7INBM8dQT1ZedlFFFSNaJy6oD7ZZ67PuXfo8edbla4Xg9U1bDL80Ui-APLjg'
      };

      var res = await http.post(url, headers: headers, body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  // for creating new user
  static Future<void> createUser() async {
    String? deviceToken = await fmMessanging.getToken();
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: "hey I am using we chat",
      createdAt: time,
      id: user.uid,
      isOnline: false,
      lastActive: time,
      pushToken: deviceToken ?? '',
      email: user.email.toString(),
    );

    return await firestore
        .collection('user')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

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

  //  chat screen realted api
  // chat collection  -> coversation (doc) => message = > message (doc)
  // getting conversation ID

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // get all converation from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
  ) async {
    final user = APIs.user;
    // Assuming you have access to the user instance here
    // Create a new message object
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      sent: time,
      fromId: user.uid,
      type: Type.text,
    );

    // final ref = firestore
    //     .collection('chats/${getConversationID(chatUser.id)}/messages/');
    // // Add te hmessage to Firestore with an auto-generated document ID
    // await ref.add(message.toJson());

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    // Add te hmessage to Firestore with an auto-generated document ID
    await ref.doc(time).set(message.toJson()).then((value) {
      sendPushNotification(chatUser, msg);
    });
  }

  // update message read status
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
