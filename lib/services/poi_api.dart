// 引入网络工具类
import '../core/network/dio_client.dart';

// POI相关接口服务：负责所有地点、搜索相关网络请求
class PoiApi {
  // 搜索地点接口，接收关键词，返回地点名称列表
  // Future 表示异步返回，需要await接收
  static Future<List<Map<String, dynamic>>> searchPlaces(String keyword) async {
    // 调用Dio客户端的get方法，请求搜索接口
    // queryParameters：把参数拼在url后面
    final response = await DioClient().get(
      '/poi/search',
      queryParameters: {'keyword': keyword},
    );

    // 从响应中取出data字段，也就是地点列表数据
    List list = response.data['data'];

    // 遍历列表，只提取每个地点的name字段，组成字符串列表返回
    return list.cast<Map<String, dynamic>>();
  }

  // ★新增：根据地点id获取详情信息
  // 返回Map类型，包含地点的所有属性（名称、经纬度、地址、简介等）
  /*1. **static**
  静态方法。意思：不用 new 这个类的对象，直接 `类名.getPoiDetail()` 就能调用。
  2. **Future<Map<String,dynamic>>**
  这是**返回值类型**

  - `Future`：代表这个方法是**异步**的，要等网络请求做完才会拿到结果（就像排队等外卖）
  - `Map<String,dynamic>`：最后拿到的数据是一个字典（json）
    - key 是字符串 `String`
    - value 随便什么类型 `dynamic`（数字、字符串、数组都行）

  3. **getPoiDetail**
  方法名字：获取 POI 详情（POI 就是地点、点位）
  4. **(int poiId)**
  参数：接收一个叫 `poiId` 的整数，就是地点的 id，用来告诉后端你要查哪个地点。
  5. **async**
  标记这个函数是异步函数，函数里面才可以写 `await`（等待网络请求）*/
  static Future<Map<String, dynamic>> getPoiDetail(int poiId) async {
    // 请求详情接口，路径里拼接地点id
    final response = await DioClient().get('/poi/detail/$poiId');

    // 返回data字段，也就是单个地点的详情字典
    return response.data['data'];
  }
}
