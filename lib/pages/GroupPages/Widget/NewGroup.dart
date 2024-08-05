import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/Contact_Controller.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:flutter_application_2/pages/GroupPages/Widget/CreateGroup.dart';
import 'package:flutter_application_2/pages/GroupPages/Widget/SelectedMember.dart';
import 'package:flutter_application_2/main.dart';
import 'package:get/get.dart';

import '../../../ModelClass/User_Details_Model.dart';

class NewGroupCreate extends StatefulWidget {
  const NewGroupCreate({super.key});

  @override
  State<NewGroupCreate> createState() => _NewGroupCreateState();
}

class _NewGroupCreateState extends State<NewGroupCreate> {
  final ContactController _contactController = Get.put(ContactController());
  final GroupController _groupController = Get.put(GroupController());

  List<Details> membersList = [];
  List<Details> filtedMember = [];
  final _searchController = TextEditingController();
  bool isSearch = false;

  void _filterItems(String query) {
    query = query.toLowerCase();
    setState(() {
      filtedMember.clear();
    });
    if (query.isEmpty) {
      setState(() {
        filtedMember = membersList;
      });
    } else {
      List<Details> filteredList = [];
      filteredList.addAll(
        membersList.where(
          (item) =>
              item.name!.toLowerCase().contains(query.toLowerCase()) ||
              item.phone!.contains(query),
        ),
      );
      setState(() {
        filtedMember = filteredList;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupController.selectMember.value = [];
  }

  @override
  void dispose() {
    _searchController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: const AutoSizeText(
          'Select member',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchController.text = value;
                  isSearch = !isSearch;
                });
                _filterItems(value.trim());
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search member',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: appColor.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.close),
                      ),
                prefixIcon: Icon(Icons.search),

                // suffixIcon: Icon(Icons.close),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => _groupController.selectMember.isNotEmpty
                  ? Row(
                      children: [
                        AutoSizeText(
                          'Selected members (${_groupController.countSelectedMember.value})',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
            const SelectedMember(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AutoSizeText(
                  'Contacts in DP Chat',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _contactController.getContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: AutoSizeText('Error=> ${snapshot.error}'),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: AutoSizeText('There is no contacts.'),
                    );
                  } else {
                    membersList = snapshot.data!;
                    return _searchController.text.isNotEmpty &&
                            filtedMember.isEmpty
                        ? Center(
                            child: Text(
                              'No contact found for "${_searchController.text}"',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchController.text.isEmpty
                                ? membersList.length
                                : filtedMember.length,
                            itemBuilder: (context, index) {
                              final contactInfo = _searchController.text.isEmpty
                                  ? membersList[index]
                                  : filtedMember[index];
                              return ListTile(
                                onTap: () {
                                  if (!_groupController.selectMember
                                      .contains(contactInfo)) {
                                    _groupController
                                        .selectGroupMember(contactInfo);
                                    _groupController
                                        .countSelectedMember.value++;
                                  }
                                },
                                title: AutoSizeText(
                                  contactInfo.name!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 17),
                                ),
                                subtitle: AutoSizeText(
                                  contactInfo.phone!,
                                  style: const TextStyle(
                                    fontSize: 15,
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
                                    child: contactInfo.photo!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: contactInfo.photo!,
                                            fit: BoxFit.fill,
                                            width: 55,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              );
                            },
                          );
                  }
                },
              ),
            ),
            Obx(
              () => _groupController.selectMember.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: appColor),
                        onPressed: () {
                          if (_groupController.selectMember.isNotEmpty) {
                            Get.off(() => const CreateGroup());
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 27,
                        ),
                        label: const Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
