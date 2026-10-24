// ① import：告诉本文件"我要用 Flutter 的基础积木库"。
//    不写这行，下面的 Scaffold、AppBar、Text 全部会报红（不认识这些词）。
import 'package:flutter/material.dart';
import 'search_page.dart';

// ② 声明一个页面类 HomePage，它继承 StatelessWidget（内容写死、不变的静态页）。
//    class = 自定义一个"东西"；extends = 借用 Flutter 现成的页面类型。
class HomePage extends StatelessWidget {
  // ③ const 构造函数：因为本页内容不变，允许用 const 创建，省内存（上节课讲过）。
  //    super.key 是把 Flutter 给这个组件的"身份证 key"原样转交，固定写法，照抄即可。
  const HomePage({super.key});

  // ④ build()：本页的"长相由这里算出来"，框架自动调用（上节课讲过）。
  //    context 是这个组件在大树里的位置坐标，框架自动传入，这里先原样保留。
  @override // 表示"重写父类的 build 方法"，固定写法，照抄。
  Widget build(BuildContext context) {
    // ⑤ Scaffold：整页骨架，提供顶栏、身体、底部栏这些标准位置。
    return Scaffold(
      // ⑥ appBar：填顶栏；AppBar 是顶栏积木；title 放顶栏中间的标题文字。
      appBar: AppBar(title: const Text("CampusPath 校径")),

      // body：顶栏下面的主要区域
      // Padding：给整块内容四周留 16 像素的白边，避免贴屏幕边缘
      body: Padding(
        padding: const EdgeInsets.all(16.0), // all(16) = 上下左右都留16
        // Column：把所有子元素从上到下竖排
        child: Column(
          //crossAxisAlignment：控制"横向"对齐方向。
          // start = 靠左（Column 默认是居中，这里改成左对齐更像正常App）
          crossAxisAlignment: CrossAxisAlignment.start,
          // children：这一列里要放的所有积木，用方括号列出来，逗号分隔
          children: [
            // ① 欢迎大标题：Text 是文字积木，style 调字号和粗细
            Text(
              "你好，欢迎来到 校径",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // ② 空盒子，撑出标题和搜索框之间的距离
            const SizedBox(height: 24),

            // InkWell：给里面的区域加"点击监听 + 水波纹"，onTap = 被点时执行
            InkWell(
              // onTap：点击后打开搜索页（和"打字搜地点"按钮是同一段跳转代码）
              onTap: () {
                Navigator.push(
                  context,
                  // builder: (_) 里的下划线 _ 表示"这个新 context 我们用不到，随便占个位置"
                  MaterialPageRoute(
                    builder: (_) => const SearchPage(source: 'box'),
                  ),
                );
              },
              // borderRadius：让水波纹也跟着圆角，不然波纹会方角溢出
              borderRadius: BorderRadius.circular(12),
              // 下面是原来的 Container，原样保留，只是现在被包在 InkWell 里面了
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 12),
                    Text(
                      "输入楼名、教室号，如：思齐楼",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // ④ 空盒子，撑出搜索框和入口之间的距离
            const SizedBox(height: 24),

            // ⑤ 入口按钮一：打字搜地点
            // ElevatedButton.icon = 自带"图标+文字横排"的凸起按钮
            ElevatedButton.icon(
              onPressed: () {
                // Navigator.push：把新页面压到卡片栈顶（打开搜索页）
                Navigator.push(
                  context, // 告诉调度员：从当前这一页出发
                  // MaterialPageRoute：新页面用 Material 风格的转场动画
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(source: 'button'),
                  ),
                );
              },
              icon: const Icon(Icons.search), // 按钮左侧图标
              label: const Text("打字搜地点"), // 按钮文字
              // style：调整按钮撑满整行宽度
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52), // 宽=占满，高=52
              ),
            ),

            // ⑥ 入口按钮二：拍照定位
            const SizedBox(height: 12), // 按钮之间的纵向间距
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("拍照功能下一步接入")));
              },
              icon: const Icon(Icons.camera_alt), //相机图标
              label: const Text("拍照识楼定位"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52), // 宽=占满，高=52
              ),
            ),

            // ⑦ 入口按钮三：语音问路
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("语音功能下一步接入")));
              },
              icon: const Icon(Icons.mic),
              label: const Text("语音问路"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52), // 宽=占满，高=52
              ),
            ),
          ],
        ),
      ),
    );
  }
}
