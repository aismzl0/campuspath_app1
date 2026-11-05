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
}
