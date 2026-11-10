// 引入Dio网络库
import 'package:dio/dio.dart';

// 网络请求客户端类，全局单例：整个App只用这一个实例，避免重复创建
class DioClient {
  // 静态私有实例，单例核心
  static final DioClient _instance = DioClient._internal();
  // 工厂构造函数：外部调用时永远返回同一个实例
  factory DioClient() => _instance;
  // 内部私有构造函数：禁止外部随便new
  DioClient._internal();

  // Dio 核心实例，真正发请求的对象
  late final Dio _dio;

  // 初始化配置：在App启动时调用一次即可
  void init() {
    // BaseOptions：Dio的全局配置
    _dio = Dio(
      BaseOptions(
        // baseUrl：接口的基础域名，后面所有接口只写后半段路径
        // 现在先写占位地址，后端搭好后换成真实地址
        baseUrl: 'http://localhost:8080/api',
        // connectTimeout：连接超时，超过5秒没连上就报错
        connectTimeout: const Duration(seconds: 5),
        // receiveTimeout：接收数据超时，超过10秒没返回就报错
        receiveTimeout: const Duration(seconds: 10),
        // 默认请求头
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 这里以后可以加拦截器：统一加token、统一打印日志、统一处理错误
  }

  // 封装get请求：外部只需要调用这个方法发get请求
  // path：接口路径；queryParameters：url后面拼接的参数
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParamaters,
  }) async {
    // 等待请求完成并返回结果
    return await _dio.get(path, queryParameters: queryParamaters);
  }

  // 封装post请求：提交数据用post
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
