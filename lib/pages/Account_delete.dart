import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AccountDelete extends StatefulWidget {
  const AccountDelete({super.key});

  @override
  State<AccountDelete> createState() => _AccountDeleteState();
}

class _AccountDeleteState extends State<AccountDelete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Delete"),
      ),
    );
  }
}
