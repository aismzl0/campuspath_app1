import 'package:flutter/material.dart';
// 地图页
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("校园地图")),
      body: const Center(child: Text("地图页面，后面接入flutter_map")),
    );
  }
}