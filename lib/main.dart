// 仍然需要 material，因为这里用到 MaterialApp、Scaffold、BottomNavigationBar
import 'package:flutter/material.dart';

// ★新增：把 pages 文件夹里的首页文件引进来，这样下面才能用 HomePage。
//   相对路径：main.dart 在 lib/，home_page.dart 在 lib/pages/，所以写 pages/home_page.dart。
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/profile_page.dart';

// 程序真正的起点：Flutter 从这里开始执行。固定写法。
void main() {
  // runApp：把根组件 MyApp 交给 Flutter 渲染。
  runApp(const MyApp());
}

// 根组件：配全局主题、窗口标题。它自己不显示内容，只负责"套壳"。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp：Material 风格应用的根容器，下面所有页面都在它里面。
    return MaterialApp(
      title: 'CampusPath 校径',
      // 全局主题：主色用蓝色，开 Material3 新样式。
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false, // 去掉右上角 DEBUG 红色水印
      // home：App 默认先打开哪一页，这里打开底部导航外壳。
      home: const HomeShellPage(),
    );
  }
}

// 底部导航外壳：动态页（点 tab 要切换、要刷新），所以用 StatefulWidget。
class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  // StatefulWidget 必须配套一个 State 类，真正存数据、画画面都在那边。
  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  // 记忆变量：当前选中第几个 tab，0 表示默认第 1 个。
  int _selectedIndex = 0;

  // 三个页面组成的列表，切换下标就能换页。这里引用的 HomePage 已从 pages 引入。
  final List<Widget> _pages = const [HomePage(), MapPage(), ProfilePage()];

  // 点底部某项时触发：套 setState 触发重绘（上节课讲过）。
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 身体显示当前选中的那一页（按下标取列表里的页面）。
      body: _pages[_selectedIndex],
      // 底部导航栏。
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "地图"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
        currentIndex: _selectedIndex, // 高亮当前项
        onTap: _onItemTapped, // 点了就调用切换方法
      ),
    );
  }
}
