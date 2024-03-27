import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/chat_information.dart';
import 'package:get/get.dart';

class ChatControler extends GetxController {
  var chatmessage = <Message>[].obs;
}

class CurrentMessageUser extends GetxController {
  var currentUser = <Details>[].obs;
}
