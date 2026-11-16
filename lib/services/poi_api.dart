// 引入网络工具类
import '../core/network/dio_client.dart';

// POI相关接口服务：负责所有地点、搜索相关网络请求
class PoiApi {
  // 搜索地点接口，接收关键词，返回地点名称列表
  // Future 表示异步返回，需要await接收
  static Future<List<String>> searchPlaces(String keyword) async {
    // 调用Dio客户端的get方法，请求搜索接口
    // queryParameters：把参数拼在url后面
    final response = await DioClient().get(
      '/poi/search',
      queryParamaters: {'keyword': keyword},
    );

    // 从响应中取出data字段，也就是地点列表数据
    List list = response.data['data'];

    // 遍历列表，只提取每个地点的name字段，组成字符串列表返回
    return list.map((item) => item['name'] as String).toList();
  }
}
