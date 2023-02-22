import 'package:flutter/material.dart';

class DrawerItemModel{
  final String title;
  final IconData icon;
  const DrawerItemModel({
    required this.title,
    required this.icon
});
}

final firstItems = [
  // const DrawerItemModel(title: 'Home', icon: Icons.home_filled),
  const DrawerItemModel(title: 'Upload', icon: Icons.upload_outlined),
  const DrawerItemModel(title: 'Chat', icon: Icons.chat_outlined),
];
final secondItems = [
  const DrawerItemModel(title: 'Setting', icon: Icons.settings),
  const DrawerItemModel(title: 'About US', icon: Icons.info_outline),
  const DrawerItemModel(title: 'Help', icon: Icons.help),
];