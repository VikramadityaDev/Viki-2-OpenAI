import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

class NetworkClient {
  Dio _dio = Dio();
  NetworkClient({String? baseUrl}) {
    baseUrl ??= "";
    BaseOptions baseOptions = BaseOptions(
      // receiveTimeout: 20000,
      // connectTimeout: 30000,
      baseUrl: baseUrl,
      maxRedirects: 2,
    );
    _dio = Dio(baseOptions);
    // adding logging interceptor.
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      error: true,
      request: false,
      requestHeader: false,
      responseBody: true,
      responseHeader: false,
    ));
  }

  // for HTTP.GET Request.
  Future<Response> get(String url,
      {Map<String, dynamic>? params, String? token}) async {
    Response response;
    try {
      Map<String, dynamic> map = {"Accept": "application/json"};
      if (token != null) map.addAll({"Authorization": "Bearer $token"});

      response = await _dio.get(url,
          queryParameters: params,
          options: Options(
            headers: map,
          ));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for HTTP.POST Request.
  Future<Response> post(String url, Map<String, dynamic> params,
      {String? token}) async {
    Response response;
    try {
      Map<String, dynamic> map = {"Accept": "application/json"};
      if (token != null) {
        map.addAll({"Authorization": "Bearer $token"});
      }
      response = await _dio.post(url,
          data: params,
          options: Options(
            headers: map,
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for HTTP.POST Request.
  Future<Response> put(String url, Map<String, dynamic> params,
      {String? token}) async {
    Response response;
    try {
      Map<String, dynamic> map = {"Accept": "application/json"};
      if (token != null) {
        map.addAll({"Authorization": "Bearer $token"});
      }
      response = await _dio.put(url,
          data: params,
          options: Options(
            headers: map,
            responseType: ResponseType.json,
            validateStatus: (_) => true,
          ));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for HTTP.PATCH Request.
  Future<Response> patch(String url, Map<String, Object> params) async {
    Response response;
    try {
      response = await _dio.patch(url,
          data: params,
          options: Options(
            responseType: ResponseType.json,
          ));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for download Request.
  Future<Response> download(String url, String pathName,
      void Function(int, int)? onReceiveProgress) async {
    Response response;
    try {
      response = await _dio.download(
        url,
        pathName,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }

  // for fileUpload Request.
  Future<Response> fileUpload(String url, FormData params) async {
    Response response;
    try {
      response = await _dio.post(url,
          data: params,
          options: Options(
            responseType: ResponseType.json,
          ));
    } on DioError catch (exception) {
      throw RemoteException(dioError: exception);
    }
    return response;
  }
}
