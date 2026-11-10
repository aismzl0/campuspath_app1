// 引入网络工具类
import '../core/network/dio_client.dart';

// POI相关接口服务：负责所有地点、搜索相关网络请求
class PoiApi {
  // 搜索地点接口
  // keyword：搜索关键词；返回Future，异步拿到结果
  static Future<List<String>> searchPlaces(String keyword) async {
    // ========== 真实后端接口写法（暂时注释，后端搭好后启用）==========
    // final response = await DioClient().get(
    //   '/poi/search',
    //   queryParameters: {'keyword': keyword},
    // );
    // // 解析后端返回的数据，提取地点名称列表
    // List list = response.data['data'];
    // return list.map((item) => item['name'] as String).toList();

    // ========== 模拟网络请求（现在用这个，假装从后端拿数据）==========
    // 延迟800毫秒，模拟网络请求的等待时间
    await Future.delayed(const Duration(milliseconds: 800));

    // 本地假数据，模拟后端返回的结果
    final allPlaces = ["思齐楼", "格物楼", "图书馆", "体育馆", "第一教学楼"];
    // 按关键词筛选，和之前本地筛选逻辑一样
    return allPlaces.where((name) => name.contains(keyword)).toList();
  }
}
