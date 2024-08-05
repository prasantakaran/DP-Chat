import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxList<Contact> contacts = <Contact>[].obs; //for storing All Contact
  RxList<String> phno = <String>[].obs; //for storing PhoneNumber
  RxList<String> contactname = <String>[].obs;
  RxMap contactPhone = {}.obs;
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  RxList<Details> allContactUser = <Details>[].obs;
  RxList<Details> userlist = <Details>[].obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    getContact().whenComplete(() {
      getUserDetails();
      update();
    });
  }

  Future getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts.value = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isEmpty ||
            contacts[i].phones[0].normalizedNumber.length < 10) continue;
        phno.add(contacts[i].phones[0].normalizedNumber.substring(3));
        String name = contacts[i].displayName;
        contactname.add(name);
        contactPhone[phno] = name;
      }
    }
  }

  Future<List<Details>> getUserDetails() async {
    try {
      // Reference to Firestore
      var firestore = FirebaseFirestore.instance;
      // Fetching user data from the 'users' collection
      var snapshot = await firestore.collection('users').get();
      var docs = snapshot.docs;

      if (docs.isNotEmpty) {
        userlist.clear();

        for (var doc in docs) {
          var data = doc.data();
          String phone = data['phone'] ?? ''; // Ensure phone is not null
          int index = phno.indexOf(phone);

          if (index != -1) {
            Details userdata = Details(
              name: contactname[index].toString(),
              email: data['email'], // Handle null value
              bio: data['bio'], // Handle null value
              photo: data['photo'], // Handle null value
              phone: data['phone'], // Handle null value
              uid: data['uid'], // Handle null value
            );

            userlist.add(userdata);
          }
        }
      } else {
        Fluttertoast.showToast(msg: "No data found");
      }
      return userlist;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  String getContactNameByPhone(String phone) {
    int index = phno.indexOf(phone);
    if (index != -1) {
      return contactname[index];
    }
    return phone; // Return phone if no contact name found
  }

  Future<void> saveContact(Details user) async {
    try {
      await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('contacts')
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<Details>> getContacts() {
    return db
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('contacts')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (e) => Details.fromJson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
