import 'package:flutter/material.dart';
// 引入地图核心包，提供FlutterMap组件
import 'package:flutter_map/flutter_map.dart';
// 引入坐标工具包，用来表示经纬度点
import 'package:latlong2/latlong.dart';

// 导航页：展示起点、终点、转向步骤列表
class NavigationPage extends StatelessWidget {
  // 两个必填参数：起点名、终点名
  final String startName;
  final String endName;

  const NavigationPage({
    super.key,
    required this.startName,
    required this.endName,
  });

  @override
  Widget build(BuildContext context) {
    // 假的转向步骤（接后端A*算法后替换成真数据）
    final List<String> steps = [
      "从起点出发，向正东方向直行 100 米",
      "右转，进入主步道",
      "直行 200 米，经过图书馆左侧",
      "左转，继续前行 80 米",
      "到达目的地：$endName",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("步行导航")),
      body: Column(
        children: [
          // ① 顶部信息栏：起点 → 终点
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("起点：$startName", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  "终点：$endName",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ★ 地图区域：替换原来的灰色占位
          // SizedBox 固定高度，给地图一个明确的高度
          SizedBox(
            height: 250,
            // FlutterMap：地图核心组件
            child: FlutterMap(
              // options：地图的基础配置
              options: MapOptions(
                // initialCenter：地图打开时的中心点，参数是经纬度 LatLng(纬度, 经度)
                // 这里先用北京天安门坐标做示例，后面换成你们学校真实坐标
                initialCenter: LatLng(39.9042, 116.4074),
                // initialZoom：初始缩放级别，数字越大地图越近、细节越多
                initialZoom: 16,
              ),
              // children：地图的图层列表，地图是一层层叠起来的
              children: [
                // TileLayer：瓦片底图层（最底层的地图画面）
                // 瓦片地图原理：把世界地图切成无数小方块，按需加载你当前看到的区域
                TileLayer(
                  // 高德路网瓦片地址模板，国内访问稳定
                  // {s} 自动替换子域名，{x}{y}{z} 对应瓦片坐标和缩放级别
                  urlTemplate:
                      'https://webrd{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
                  // 瓦片可用的子域名列表，自动分配请求以加速加载
                  subdomains: const ['01', '02', '03', '04'],
                  // App身份标识，保持项目专属名称
                  userAgentPackageName: 'com.campuspath.app',
                ),
                // 折线图层：绘制导航步行路线，叠在底图上方、标记点下方
                PolylineLayer(
                  // polylines：所有折线的集合，当前只有一条导航路线
                  polylines: [
                    // 单条路线对象
                    Polyline(
                      // points：组成路线的经纬度点列表，按顺序依次连接
                      // 当前为模拟路径点，后续接入后端后替换为A*算法返回的真实路径
                      points: [
                        LatLng(39.9042, 116.4074), // 起点坐标
                        LatLng(39.9052, 116.4084), // 路线中间点1
                        LatLng(39.9072, 116.4084), // 路线中间点2
                        LatLng(39.9082, 116.4094), // 终点坐标
                      ],
                      // color：路线线条的颜色
                      color: Colors.blue,
                      //strokeWidth:路线线条的粗细
                      strokeWidth: 4,
                    ),
                  ],
                ),

                // 标记点图层：叠在瓦片底图上方，用来放置起点、终点图标
                MarkerLayer(
                  // markers：所有标记点的列表
                  markers: [
                    // 起点标记
                    Marker(
                      // point：标记点钉在地图上的经纬度坐标
                      // 这里先用示例坐标，后续接真实定位/后端数据后替换
                      point: LatLng(39.9042, 116.4074),
                      // width/height：标记图标的尺寸
                      width: 40,
                      height: 40,
                      // anchor：锚点，让图标底部对准坐标点，而不是图标中心
                      // 这样图钉尖正好落在经纬度位置上，符合视觉习惯
                      alignment: Alignment.bottomCenter,
                      // child：标记点显示的组件，这里用绿色定位图标代表起点
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),

                    //终点标记
                    Marker(
                      point: LatLng(39.9082, 116.4094),
                      width: 40,
                      height: 40,
                      alignment: Alignment.bottomCenter,
                      // 红色目的地图标代表终点
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                // 版权声明组件：合规标注地图数据来源
                RichAttributionWidget(
                  attributions: [TextSourceAttribution('高德地图 AutoNavi')],
                ),
              ],
            ),
          ),

          // ③ 步骤列表标题
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "转向步骤",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ④ 步骤列表（Expanded 占满剩余高度，可滚动）
          Expanded(
            child: ListView.builder(
              // itemCount：列表总条数
              itemCount: steps.length,
              // itemBuilder：第 index 行怎么画
              itemBuilder: (context, index) {
                final step = steps[index];
                return ListTile(
                  // 左侧序号圆圈
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  // 主标题：步骤文字
                  title: Text(step),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
