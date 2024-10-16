import 'package:dio/dio.dart';

class ApiHelper {
  final String baseUrl = "https://remoteok.com/api";
  static Dio? _dio;

  ApiHelper._(); // Private constructor

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://remoteok.com/api",
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  static Future<Response> getData({
    String path ="https://remoteok.com/api",
    Map<String, dynamic>? queryParameters,
  }) async {
    // Ensure that _dio is initialized
    if (_dio == null) {
      throw Exception("Dio is not initialized. Call ApiHelper.init() first.");
    }

    // Use the full path
    final response = await _dio!.get(path, queryParameters: queryParameters);
    return response;
  }
}
