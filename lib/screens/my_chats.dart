import 'package:flutter/material.dart';

class MyChats extends StatefulWidget {
  static const routeName = "/my_chats";

  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Chats'),),
    );
  }
}
