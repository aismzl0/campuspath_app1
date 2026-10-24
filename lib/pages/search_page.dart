// 引入基础积木库
import 'package:flutter/material.dart';

// 搜索页：静态占位页（结果列表下一步才接），继承 StatelessWidget
class SearchPage extends StatefulWidget {
  // ★新增：配置字段，记录"用户是从哪进来的"。
  // final = 传进来后不再变；{} = 命名参数；'button' = 不传时的默认值。
  final String source;
  const SearchPage({super.key, this.source = 'button'});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

// ③ 内层 State 类：真正存放"当前输入内容"、决定画面的地方
class _SearchPageState extends State<SearchPage> {
  // 遥控器：夹在程序和输入框之间，用它读用户打的字。
  // 下划线开头 _controller 表示"内部私有，别的类不用管它"。
  final _controller = TextEditingController();
  // 本地假数据：几个楼名。等接后端后，这里换成真实搜索结果。
  final List<String> _mockPlaces = ["思齐楼", "格物楼", "图书馆", "体育馆", "第一教学楼"];

  // ★ dispose：页面被关闭/销毁时自动调用（生命周期方法）。
  // 遥控器用完必须 dispose 释放，否则一直占内存（内存泄漏），这是固定规矩。
  @override
  void dispose() {
    _controller.dispose(); // 先释放自己的遥控器
    super.dispose(); // 再调用父类的清理，顺序固定，照抄
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("搜索地点")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              // ★把遥控器接到输入框：之后才能用 _controller.text 读到内容
              controller: _controller,
              decoration: InputDecoration(
                hintText: "输入楼名、教室号，如：思齐楼",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ★新增"搜索"按钮：点了就读取用户输入的字
            ElevatedButton(
              onPressed: () {
                final text = _controller.text;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('你搜了：$text')));
              },
              child: const Text('搜索'),
            ),
            const SizedBox(height: 8),
            // ★注意：StatefulWidget 里读外层参数，要写成 widget.source，不能直接写 source
            Text("进入来源：${widget.source}"),

            // ★新增：结果列表区
            const SizedBox(height: 24),
            const Text(
              "附近地点（示例）",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Expanded：让 ListView 在 Column 里占满剩余高度（不包会报"无高度"错）
            Expanded(
              // ListView：可滚动的一长串条目
              child: ListView(
                // collection-for：遍历假数据，每个楼名生成一行 ListTile（等价于你熟悉的 for 循环）
                children: [
                  for (final name in _mockPlaces)
                    ListTile(
                      leading: const Icon(Icons.place, color: Colors.blue),
                      title: Text(name),
                      onTap: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('选中：$name')));
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
