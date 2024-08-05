// ignore_for_file: implementation_imports, unnecessary_import, no_logic_in_create_state, must_be_immutable, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';

class ShowContactImage extends StatefulWidget {
  // const ShowContactImage({super.key});
  Details user;
  ShowContactImage(this.user);

  @override
  State<ShowContactImage> createState() => _ShowContactImageState(user);
}

class _ShowContactImageState extends State<ShowContactImage> {
  Details user;
  _ShowContactImageState(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // child: Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: BoxDecoration(
        //     color: Colors.transparent,
        //     // image: DecorationImage(
        //     //   image: NetworkImage(Myurl.fullurl + Myurl.imageurl + user.photo),
        //     // ),

        //   ),
        // ),

        child: InteractiveViewer(
          maxScale: 5.0,
          minScale: 0.01,
          child: CachedNetworkImage(
            imageUrl: user.photo!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(image: imageProvider)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
