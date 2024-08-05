import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:flutter_application_2/ModelClass/GroupModel.dart';
import 'package:flutter_application_2/pages/GroupPages/Widget/AddNew_GroupMember.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../Contact_Access.dart';

// ignore: must_be_immutable
class GroupProfile extends StatefulWidget {
  GroupProfile({super.key, required this.groupModel});
  GroupModel groupModel;

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  final GroupController _groupController = Get.put(GroupController());
  final groupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final groupInfo = widget.groupModel;
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: AutoSizeText(
          groupInfo.name!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: appColor, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: screenHeight * 0.2,
                            width: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: ClipOval(
                              child: groupInfo.profileUrl! != ''
                                  ? Image.network(
                                      groupInfo.profileUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.group_add_outlined,
                                      size: screenHeight * 0.1,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          // Positioned(
                          //   left: screenHeight * 0.15,
                          //   bottom: 5,
                          //   child: IconButton(
                          //     onPressed: () {
                          //       showModalBottomSheet(
                          //         shape: const RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.only(
                          //             topLeft: Radius.circular(20),
                          //             topRight: Radius.circular(20),
                          //           ),
                          //         ),
                          //         context: context,
                          //         builder: (context) =>
                          //             _imagePickedDailog.bottomSheet(context),
                          //       );
                          //     },
                          //     icon: Icon(
                          //       Icons.add_a_photo_rounded,
                          //       size: screenHeight * 0.04,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    AutoSizeText(
                      groupInfo.name!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const AutoSizeText(
                      'No description is there.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    // Form(
                    //   key: groupKey,
                    //   child: TextFormField(
                    //     controller: _textController,
                    //     autovalidateMode: AutovalidateMode.onUserInteraction,
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Enter Your Name';
                    //       }
                    //       return null;
                    //     },
                    //     decoration: const InputDecoration(
                    //       filled: true,
                    //       fillColor: Colors.white38,
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       ),
                    //       hintText: 'Group name',
                    //       prefixIcon: Icon(
                    //         Icons.groups_2_outlined,
                    //         size: 27,
                    //         color: Colors.white,
                    //       ),
                    //       hintStyle: TextStyle(
                    //         fontSize: 15,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        '${groupInfo.members!.length.toString()} Members',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          backgroundColor: appColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewMember(
                              group_id: groupInfo.id!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person_add_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add member',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: groupInfo.members!
                    .map(
                      (member) => ListTile(
                        title: AutoSizeText(member.name!),
                        subtitle: AutoSizeText(member.phone!),
                        trailing: AutoSizeText(
                          member.role == "admin" ? 'Admin' : "",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Container(
                          decoration: BoxDecoration(
                            color: appColor,
                            border: Border.all(color: appColor),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          height: 55,
                          width: 55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: member.photo!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: member.photo!,
                                    fit: BoxFit.cover,
                                    // width: 55,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10, right: 10),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 50,
              //     child: ElevatedButton.icon(
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         backgroundColor: appColor,
              //       ),
              //       onPressed: () {
              //         if (groupKey.currentState!.validate() &&
              //             _textController.text.isNotEmpty) {
              //           Navigator.pop(context);
              //           snackBarController.snackBar(
              //             context,
              //             'Group created successfully',
              //             Colors.green,
              //           );
              //         } else {
              //           snackBarController.snackBar(
              //             context,
              //             'Please provide the necessary group information',
              //             Colors.red,
              //           );
              //         }
              //       },
              //       icon: const Icon(
              //         Icons.done,
              //         color: Colors.white,
              //         size: 27,
              //       ),
              //       label: const Text(
              //         'Create group',
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.white,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Obx(
                () {
                  return _groupController.isLoading.isTrue
                      ? const Center(child: CircularProgressIndicator())
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
