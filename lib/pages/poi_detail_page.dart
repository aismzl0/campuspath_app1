// 引入Flutter基础组件库
import 'package:flutter/material.dart';
// 引入POI接口服务
import '../services/poi_api.dart';


// 地点详情页：需要异步请求数据，有加载状态，所以继承StatefulWidget
class PoiDetailPage extends StatefulWidget {
  // 必填参数：地点id，用来请求详情数据
  final int poiId;
  // 兼容旧的name参数，方便之前的调用处不用立刻全改
  final String? name;

  const PoiDetailPage({super.key,required this.poiId,this.name})

  @override
  State<PoiDetailPage> createState() => _PoiDetailPageState();
}


class _PoiDetailPageState extends State<PoiDetailPage> {
  // 详情数据，初始为空
  Map<String,dynamic>?_detail;
  //加载状态
  bool _isLoading = true;
  // 错误信息
  String? _error;

  // 页面创建时自动调用：发起请求获取详情
  @override
  void initState(){
    super.initState();
    _loadDetail();
  }

  // 异步加载详情数据
  Future<void> _loadDetail() async{
    try{
      //调用接口获取数据
      final data = await PoiApi.getPoiDetail(widget.poiId);
      //请求成功：更新数据、关闭加载
      setState(() {
        _detail = data;
        _isLoading = false;
      });
    } catch(e){
      // 请求失败：记录错误、关闭加载
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(
      title: Text(_detail?['name']??widget.name??'地点详情'),
    ),
    body: Padding(padding: const EdgeInsets.all(16),
      child: _buildBody(),
    ),
    );
  }


  // 根据状态渲染不同的页面内容
  Widget _buildBody() {
    // 加载中：显示转圈动画
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 加载出错：显示错误提示
    if (_error != null) {
      return Center(child: Text('加载失败：$_error'));
    }

    // 加载成功：显示详情内容
    final detail = _detail!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 地点名称大标题
        Text(
          detail['name'],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // 地址信息
        Text("地址：${detail['address'] ?? '暂无'}"),
        const SizedBox(height: 8),

        // 简介信息
        Text("简介：${detail['description'] ?? '暂无'}"),
        const SizedBox(height: 8),

        // 经纬度信息（调试用，真实App可以隐藏）
        Text("坐标：${detail['latitude']}, ${detail['longitude']}"),

        const SizedBox(height: 24),
        // 开始导航按钮
        ElevatedButton(
          onPressed: () {
            // 跳转到导航页，传入起点终点名称和坐标
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NavigationPage(
                  startName: "我的位置",
                  endName: detail['name'],
                ),
              ),
            );
          },
          child: const Text("开始导航"),
        ),
      ],
    );
  }
}


// 临时导入导航页，避免报错
import 'navigation_page.dart';