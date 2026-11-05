// 引入基础积木库
import 'package:flutter/material.dart';
import 'navigation_page.dart'; // ★引入导航页

// 地点详情页：只负责展示一个地点的信息，内容写死、不交互变化，用 StatelessWidget
class PoiDetailPage extends StatelessWidget {
  final String name;
  const PoiDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 占位信息：接后端后换成真实地址
            const Text("地址：示例地址（接后端后显示真实位置）"),
            const SizedBox(height: 8),
            // 占位简介
            const Text("简介：这里显示地点介绍、开放时间等信息"),

            const SizedBox(height: 24),
            // ★开始导航按钮：先弹提示，导航页下一轮做
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NavigationPage(
                      startName: "我的位置", // 起点暂时写死，后面接定位后替换
                      endName: name, // 终点就是当前详情页的地点名
                    ),
                  ),
                );
              },
              child: const Text("开始导航"),
            ),
          ],
        ),
      ),
    );
  }
}
