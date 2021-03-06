import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hello_flutter/res/constant.dart';
import 'package:hello_flutter/util/device_util.dart';
import 'package:hello_flutter/util/log_util.dart';
import 'package:hello_flutter/util/other_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

import 'error_handle.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String accessToken = SpUtil.getString(AppConstant.accessToken).nullSafe;
    options.headers['Content-Type'] = 'application/json';
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = '$accessToken ';
    }
    if (!DeviceUtil.isWeb) {
      //  https://developer.github.com/v3/#user-agent-required
      options.headers['User-Agent'] = 'Mozilla/5.0';
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    Logger.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Logger.d('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      Logger.d(
          'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    Logger.d('RequestMethod: ${options.method}');
    Logger.d('RequestHeaders:${options.headers}');
    Logger.d('RequestContentType: ${options.contentType}');
    Logger.d('RequestData: ${options.data.toString()}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Logger.d('ResponseCode: ${response.statusCode}');
    } else {
      Logger.e('ResponseCode: ${response.statusCode}');
    }
    // ????????????
    Logger.json(response.data.toString());
    Logger.d('----------End: $duration ??????----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger.d('----------Error-----------');
    super.onError(err, handler);
  }
}

class AdapterInterceptor extends Interceptor {
  static const String _kMsg = 'msg';
  static const String _kSlash = "'";
  static const String _kMessage = 'msg';

  static const String _kDefaultText = '???????????????';
  static const String _kNotFound = '?????????????????????';

  static const String _kFailureFormat = '{"code":%d,"msg":"%s"}';
  static const String _kSuccessFormat = '{"code":0,"data":%s,"msg":""}';

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final Response r = adapterData(response);
    super.onResponse(r, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    super.onError(err, handler);
  }

  Response adapterData(Response response) {
    String result;
    String content = response.data?.toString() ?? '';

    /// ?????????????????????????????????
    if (response.statusCode == ExceptionHandle.success ||
        response.statusCode == ExceptionHandle.success_not_content) {
      if (content.isEmpty) {
        content = _kDefaultText;
      }
      result = sprintf(_kSuccessFormat, [content]);
      response.statusCode = ExceptionHandle.success;
    } else {
      if (response.statusCode == ExceptionHandle.not_found) {
        /// ???????????????????????????????????????????????????
        result = sprintf(_kFailureFormat, [response.statusCode, _kNotFound]);
        response.statusCode = ExceptionHandle.success;
      } else {
        if (content.isEmpty) {
          //  ??????????????????????????????
          result = content;
        } else {
          String msg;
          try {
            content = content.replaceAll(r'\', '');
            if (_kSlash == content.substring(0, 1)) {
              content = content.substring(1, content.length - 1);
            }
            final Map<String, dynamic> map = json.decode(content) as Map<String, dynamic>;
            if (map.containsKey(_kMessage)) {
              msg = map[_kMessage] as String;
            } else if (map.containsKey(_kMsg)) {
              msg = map[_kMsg] as String;
            } else {
              msg = '????????????';
            }
            result = sprintf(_kFailureFormat, [response.statusCode, msg]);
            // 401 token ????????????????????????????????????????????????
            if (response.statusCode == ExceptionHandle.unauthorized) {
              response.statusCode = ExceptionHandle.unauthorized;
            } else {
              response.statusCode = ExceptionHandle.success;
            }
          } catch (e) {
//            Log.d('???????????????$e');
            // ??????????????????????????????????????????????????????????????? 500,503 HTML ???????????????
            result =
                sprintf(_kFailureFormat, [response.statusCode, '???????????????(${response.statusCode})']);
          }
        }
      }
    }
    response.data = result;
    return response;
  }
}
