// 引入Dio网络请求库
import 'package:dio/dio.dart';

// 网络请求客户端：全局单例，整个App共用一个实例
class DioClient {
  // 静态私有实例：单例核心，程序运行期间只有这一份
  static final DioClient _instance = DioClient._internal();

  // 工厂构造函数：外部调用 DioClient() 时，永远返回同一个实例
  factory DioClient() => _instance;

  // 内部私有构造函数：禁止外部随便new新实例
  // 在这里直接完成Dio的初始化，不用外部手动调用init
  DioClient._internal() {
    // 创建Dio实例并配置全局参数
    _dio = Dio(
      BaseOptions(
        // baseUrl：接口基础域名，所有接口只需要写后半段路径
        baseUrl: 'http://localhost:8080/api',
        // 连接超时：5秒连不上就报错
        connectTimeout: const Duration(seconds: 5),
        // 接收超时：10秒没返回数据就报错
        receiveTimeout: const Duration(seconds: 10),
        // 默认请求头：声明发送的是JSON格式数据
        headers: {'Content-type': 'application/json'},
      ),
    );
  }

  // Dio核心实例：真正负责发请求的对象
  late final Dio _dio;

  // 封装GET请求：外部调用这个方法发起get请求
  // path：接口路径；queryParameters：url后面拼接的查询参数
  // Future<Response>：异步返回响应结果，需要await接收
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    // 等待请求完成，返回响应结果
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // 封装POST请求：提交数据时使用
  // path：接口路径；data：请求体数据
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
