import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/log_util.dart';

import 'base_entity.dart';
import 'error_handle.dart';

/// 默认 dio 配置
int _connectTimeout = 5000;
int _receiveTimeout = 5000;
int _sendTimeout = 10000;
String _baseUrl = '';
List<Interceptor> _interceptors = [];

/// 初始化Dio配置
void configDio({
  int? connectTimeout,
  int? receiveTimeout,
  int? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback = Function(int code, String msg);

class DioUtil {
  factory DioUtil() => _singleton;

  DioUtil._() {
    final BaseOptions _options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio 默认 json 解析，这里指定返回 UTF8 字符串，自己处理解析。（可也以自定义 Transformer 实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用 http 状态码判断状态，使用 AdapterInterceptor 来处理（适用于标准 REST 风格）
        return true;
      },
      baseUrl: _baseUrl,
      // contentType: Headers.formUrlEncodedContentType, // 适用于 post form 表单提交
    );
    _dio = Dio(_options);

    /// 添加拦截器
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }

    _interceptors.forEach(addInterceptor);
  }

  static final DioUtil _singleton = DioUtil._();

  static DioUtil get instance => DioUtil();

  static late Dio _dio;

  Dio get dio => _dio;

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();

      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      /// 使用 compute 条件：数据大于 10KB（粗略使用10 * 1024）且当前不是集成测试（后面可能会根据 Web 环境进行调整）
      /// 主要目的减少不必要的性能开销
      final bool isCompute = !AppConstant.isDriverTest && data.length > 10 * 1024;
      debugPrint('isCompute:$isCompute');
      final Map<String, dynamic> _map =
          isCompute ? await compute(parseData, data) : parseData(data);
      return BaseEntity<T>.fromJson(_map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity<T>(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  Future requestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request<T>(
      method.value,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then<void>(
      (BaseEntity<T> result) {
        if (result.code == 0) {
          onSuccess?.call(result.data);
        } else {
          _onError(result.code, result.message, onError);
        }
      },
      onError: (dynamic e) {
        _cancelLogPrint(e, url);
        final NetError error = ExceptionHandle.handleException(e);
        _onError(error.code, error.msg, onError);
      },
    );
  }

  /// 统一处理(onSuccess 返回 T 对象，onSuccessList 返回 List<T>)
  void asyncRequestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    Stream.fromFuture(_request<T>(
      method.value,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )).asBroadcastStream().listen(
      (result) {
        if (result.code == 0) {
          if (onSuccess != null) {
            onSuccess(result.data);
          }
        } else {
          _onError(result.code, result.message, onError);
        }
      },
      onError: (dynamic e) {
        _cancelLogPrint(e, url);
        final NetError error = ExceptionHandle.handleException(e);
        _onError(error.code, error.msg, onError);
      },
    );
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Logger.e('取消请求接口： $url');
    }
  }

  void _onError(int? code, String msg, NetErrorCallback? onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Logger.e('接口请求异常： code: $code, msg: $msg');
    onError?.call(code, msg);
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch 判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
