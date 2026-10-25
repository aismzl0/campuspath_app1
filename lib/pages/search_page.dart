// 引入基础积木库
import 'package:flutter/material.dart';
import 'poi_detail_page.dart';

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
  // ★新增：当前要显示的结果列表。初始先放全部，进页面就能看到内容。
  List<String> _results = [];

  // ★新增：点搜索时执行的筛选逻辑
  void _onSearch() {
    // 1. 读出输入框的词，去掉首尾空格
    final keyword = _controller.text.trim();

    // 2. 准备一个空列表，用来装匹配到的楼名
    final List<String> matched = [];

    // 3. 遍历所有假楼名（用你熟悉的 for）
    for (final name in _mockPlaces) {
      // 空词 → 全部保留；有词 → 只留名字里包含这个词的
      if (keyword.isEmpty || name.contains(keyword)) {
        matched.add(name); // 符合条件就装进 matched
      }
    }
    // 4. 用 setState 把结果换掉并触发重绘（前几课的开关）
    setState(() {
      _results = matched;
    });
  }

  // ★initState：页面创建时自动调用一次，用来做初始化。固定先调 super.initState()。
  @override
  void initState() {
    super.initState(); // 父类初始化，固定照抄，必须写在第一行
    // 页面刚进来，把全部假楼名复制一份作为初始结果
    _results = List.from(_mockPlaces);
  }

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
              onPressed: _onSearch, // 直接把方法交给按钮，点了就执行 _onSearch
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
                  for (final name in _results)
                    ListTile(
                      leading: const Icon(Icons.place, color: Colors.blue),
                      title: Text(name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PoiDetailPage(name: name),
                          ),
                        );
                      },
                    ),
                  // ★空状态：结果一条都没有时，显示一句提示（不再显示空白）
                  if (_results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text("没有找到相关地点，换个词试试")),
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
