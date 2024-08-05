import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:flutter_application_2/widgets/ImagePickedDailog.dart';
import 'package:get/get.dart';
import '../../../main.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final GroupController _groupController = Get.put(GroupController());
  final ImagePickedDialog _imagePickedDailog = Get.put(ImagePickedDialog());
  final TextEditingController _textController = TextEditingController();
  final groupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: const AutoSizeText(
          'Create group',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: appColor),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          child: Obx(
                            () => ClipOval(
                              child: _imagePickedDailog.file.value != null
                                  ? Image.file(
                                      File(_imagePickedDailog.file.value!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.group_add_outlined,
                                      size: screenHeight * 0.1,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: screenHeight * 0.15,
                          bottom: 5,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) =>
                                    _imagePickedDailog.bottomSheet(context),
                              );
                            },
                            icon: Icon(
                              Icons.add_a_photo_rounded,
                              size: screenHeight * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: groupKey,
                    child: TextFormField(
                      controller: _textController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Your Name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white38,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: 'Group name',
                        prefixIcon: Icon(
                          Icons.groups_2_outlined,
                          size: 27,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  AutoSizeText(
                    'You have selected the following members.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GetBuilder<GroupController>(
              builder: (controller) {
                return SizedBox(
                  height: screenHeight * 0.4,
                  child: ListView(
                    children: controller.selectMember
                        .map(
                          (e) => ListTile(
                            title: AutoSizeText(e.name!),
                            subtitle: AutoSizeText(e.phone!),
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
                                child: e.photo!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: e.photo!,
                                        fit: BoxFit.fill,
                                        width: 55,
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
                            trailing: controller.selectMember.length > 1
                                ? IconButton(
                                    onPressed: () {
                                      controller.selectMember.remove(e);
                                      controller.update();
                                    },
                                    icon: Icon(Icons.clear),
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: appColor,
                  ),
                  onPressed: () {
                    if (groupKey.currentState!.validate() &&
                        _textController.text.isNotEmpty) {
                      _groupController.createGroup(
                        _textController.text,
                        _imagePickedDailog.file.value != null
                            ? File(_imagePickedDailog.file.value!.path)
                            : null,
                      );
                      Navigator.pop(context);
                      snackBarController.snackBar(
                        context,
                        'Group created successfully',
                        Colors.green,
                      );
                    } else {
                      snackBarController.snackBar(
                        context,
                        'Please provide the necessary group information',
                        Colors.red,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 27,
                  ),
                  label: const Text(
                    'Create group',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
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
    );
  }
}
