import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:photo_view/photo_view.dart';

import 'User_Details_Model.dart';

class ProfileScreen extends StatefulWidget {
  // const ProfileScreen({super.key});
  Details user;
  ProfileScreen(this.user);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  Details user;
  _ProfileScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverPersistentDelegate(user),
            pinned: true,
          ),
          //Lets create a long list to make the content scrollable
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).dialogBackgroundColor,
                  child: Column(
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.phone,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300)
              ],
            ),
          )
        ],
      ),
    );

    // return Stack(
    //   children: [
    //     Container(
    //       decoration: const BoxDecoration(
    //         gradient: LinearGradient(
    //             colors: [
    //               Color.fromRGBO(4, 9, 35, 1),
    //               Color.fromRGBO(39, 105, 171, 1)
    //             ],
    //             begin: FractionalOffset.bottomCenter,
    //             end: FractionalOffset.topCenter),
    //       ),
    //     ),
    //     Scaffold(
    //       backgroundColor: Colors.transparent,
    //       body: SingleChildScrollView(
    //         child: SafeArea(
    //           child: Padding(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 15,
    //               vertical: 20,
    //             ),
    //             child: Column(
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       icon: Icon(Icons.arrow_back),
    //                     ),
    //                     IconButton(
    //                       onPressed: () {},
    //                       icon: Icon(Icons.more_vert_outlined),
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 Text(
    //                   "My\nProfile",
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       fontFamily: 'PangolinRegular',
    //                       fontSize: 30,
    //                       color: Colors.white),
    //                 ),
    //                 // SizedBox(
    //                 //   height: 25,
    //                 // ),
    //                 Container(
    //                   alignment: Alignment.center,
    //                   width: width * 0.3,
    //                   height: height * 0.2,
    //                   child: CircleAvatar(
    //                     radius: 80,
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 35;
  final double maxImgSize = 130;
  final double minImgSize = 40;
  Details user;
  SliverPersistentDelegate(this.user);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / (maxHeaderHeight);
    final currentImgSize = (maxHeaderHeight * (1 - percent)).clamp(
      minImgSize,
      maxImgSize,
    );
    final currentImgPosition =
        ((size.width / 2 - 65) * (1 - percent)).clamp(minImgSize, maxImgSize);
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Container(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor
            ?.withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: const BackButton(
                  // color: Colors.white,
                  ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    // color: Colors.white,
                  )),
            ),
            Positioned(
              left: currentImgPosition,
              top: MediaQuery.of(context).viewPadding.top + 5,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => Container(
                            child: user.photo != ""
                                ? PhotoView(
                                    maxScale: 5.0,
                                    minScale: 0.5,
                                    imageProvider: NetworkImage(Myurl.fullurl +
                                        Myurl.imageurl +
                                        user.photo))
                                : Container(
                                    color: Colors.transparent,
                                    width: currentImgSize,
                                    child: Center(
                                      child: Text(
                                        "No image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            letterSpacing: 0.5,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ));
                },
                child: user.photo != ""
                    ? Container(
                        width: currentImgSize,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(Myurl.fullurl +
                                    Myurl.imageurl +
                                    user.photo))),
                      )
                    : Container(
                        width: currentImgSize,
                        child: CircleAvatar(
                          radius: 100,
                          child: Icon(
                            Icons.person,
                            size: 80,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
