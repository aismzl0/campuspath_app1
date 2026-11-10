// 引入基础积木库
import 'package:flutter/material.dart';
import 'poi_detail_page.dart';
import '../services/poi_api.dart'; // 新增：引入POI接口服务

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
  // 搜索结果列表，初始为空
  List<String> _results = [];
  // 加载状态标记：true=正在请求中，界面显示加载动画
  bool _isLoasing = false;

  // 点击搜索按钮时执行：发请求拿数据，更新界面
  void _onSearch() async {
    // 拿到输入框的关键词，去掉首尾空格
    final keyword = _controller.text.trim();

    // 已经在加载中就直接返回，防止重复点击
    if (_isLoasing) return;

    try {
      // 开始加载：标记为true，触发界面刷新显示加载动画
      setState(() {
        _isLoasing = true;
      });

      // 等待接口返回搜索结果
      final list = await PoiApi.searchPlaces(keyword);

      // 请求成功：更新结果列表
      setState(() {
        _results = list;
      });
    } catch (e) {
      // 请求出错：弹出错误提示
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('搜索失败：$e')));
      }
    } finally {
      // finally 块：无论成功还是失败，一定会执行
      // 保证加载状态一定会关闭，避免出错后一直转圈
      if (mounted) {
        setState(() {
          _isLoasing = false;
        });
      }
    }
  }

  // ★initState：页面创建时自动调用一次，用来做初始化。固定先调 super.initState()。
  @override
  void initState() {
    super.initState(); // 父类初始化，固定照抄，必须写在第一行
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
              // 加载中时 onPressed 设为 null，按钮自动变灰不可点
              onPressed: _isLoasing
                  ? null
                  : _onSearch, // 直接把方法交给按钮，点了就执行 _onSearch
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
              // 根据加载状态显示不同内容
              child: ListView(
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
                  // 结果为空时显示提示
                  if (_results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('没有找到相关地点，换个词试试')),
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
