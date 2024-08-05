import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:get/get.dart';

import '../../../main.dart';

class SelectedMember extends StatefulWidget {
  const SelectedMember({super.key});

  @override
  State<SelectedMember> createState() => _SelectedMemberState();
}

class _SelectedMemberState extends State<SelectedMember> {
  @override
  Widget build(BuildContext context) {
    GroupController _groupController = Get.put(GroupController());

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _groupController.selectMember
            .map(
              (e) => ListTile(
                title: AutoSizeText(e.name!),
                subtitle: AutoSizeText(e.phone!),
                trailing: IconButton(
                  onPressed: () {
                    _groupController.selectMember.remove(e);
                    _groupController.countSelectedMember.value--;
                  },
                  icon: const Icon(
                    Icons.clear,
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
                    child: e.photo!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: e.photo!,
                            fit: BoxFit.fill,
                            width: 55,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
    );
  }
}
