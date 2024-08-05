import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickedDialog extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var file = Rx<XFile?>(null);

  Future<void> pickImage(ImageSource source) async {
    XFile? _tmpFile = await _picker.pickImage(source: source);
    if (_tmpFile != null) {
      file.value = _tmpFile;
    }
  }

  Widget bottomSheet(BuildContext context) {
    return Card(
      elevation: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.highlight_remove_sharp, color: Colors.red),
            title: Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text(
              'Gallery',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              Navigator.pop(context);
              await pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text(
              'Camera',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              Navigator.pop(context);
              await pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
