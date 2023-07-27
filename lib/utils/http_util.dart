import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:member_manage_web/models/response_model.dart';
import 'package:member_manage_web/utils/log_util.dart';

typedef Json = Map<String, dynamic>;

enum FetchType { head, get, post, put, patch, delete }

class HttpUtil {
  const HttpUtil._();

  static const String _tag = '🌐 HttpUtil';
  static bool isLogging = true;

  static late final Dio dio;

  static final BaseOptions baseOptions = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    receiveDataWhenStatusError: true,
    baseUrl: 'http://localhost:8080/api',
  );

  static Future<void> init() async {
    dio = Dio()
      ..options = baseOptions
      ..interceptors.addAll([_interceptor]);
  }

  static ResponseModel _successModel() =>
      ResponseModel(code: 0, message: 'success');

  static ResponseModel _failModel(String? message) =>
      ResponseModel(code: 1, message: '$message');

  static ResponseModel _cancelledModel(
    String? message,
    String url,
  ) =>
      ResponseModel(code: 1, message: '$message, $url');

  static Future<T?> fetch<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String>? queryParameters,
    Object? body,
    Json? headers,
    String? contentType,
    ResponseType? responseType,
    CancelToken? cancelToken,
    T Function(dynamic data)? dataConverter,
  }) async {
    final Response<dynamic> response = await getResponse(
      fetchType,
      url: url,
      queryParameters: queryParameters,
      body: body,
      headers: headers,
      contentType: contentType,
      responseType: responseType,
      cancelToken: cancelToken,
    );
    if (response.data == null) {
      return null;
    }
    final resModel = response.data! is String
        ? ResponseModel.fromJson(jsonDecode(response.data!))
        : ResponseModel.fromJson(response.data!);
    if (resModel.isError || resModel.data == null) {
      return null;
    }
    return dataConverter?.call(resModel.data!) ?? resModel.data!;
  }

  static Future<Response<T>> getResponse<T>(
    FetchType fetchType, {
    required String url,
    Map<String, String?>? queryParameters,
    Object? body,
    Json? headers,
    String? contentType,
    ResponseType? responseType = ResponseType.json,
    CancelToken? cancelToken,
    bool Function(Json json)? modelFilter,
  }) async {
    headers ??= <String, String?>{};
    // System headers.
    if (body != null) {
      headers[HttpHeaders.contentTypeHeader] ??= Headers.jsonContentType;
    }
    // Recreate <String, String> headers and queryParameters.
    final Json effectiveHeaders = headers.map<String, dynamic>(
      (String key, dynamic value) =>
          MapEntry<String, dynamic>(key, value.toString()),
    );
    final Uri replacedUri = Uri.parse(url).replace(
      queryParameters: queryParameters?.map<String, String>(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value.toString()),
      ),
    );
    final Options options = Options(
      followRedirects: true,
      headers: effectiveHeaders,
      receiveDataWhenStatusError: true,
      contentType: contentType,
      responseType: responseType,
    );

    final Response<T> response;
    switch (fetchType) {
      case FetchType.head:
        response = await dio.headUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.get:
        response = await dio.getUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.post:
        response = await dio.postUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.put:
        response = await dio.putUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.patch:
        response = await dio.patchUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
      case FetchType.delete:
        response = await dio.deleteUri(
          replacedUri,
          data: body,
          options: options,
          cancelToken: cancelToken,
        );
        break;
    }
    if (response.data == '') {
      response.data = null;
    }
    return response;
  }

  static void _log(
    Object? message, {
    StackTrace? stackTrace,
    bool isError = false,
  }) {
    if (isLogging) {
      if (isError) {
        LogUtil.e(message, stackTrace: stackTrace, tag: _tag);
      } else {
        LogUtil.d(message, stackTrace: stackTrace, tag: _tag);
      }
    }
  }

  static QueuedInterceptorsWrapper get _interceptor {
    return QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        _log('Fetching(${options.method}) url: ${options.uri}');
        if (options.headers.isNotEmpty) {
          _log('Raw request headers: ${options.headers}');
        }
        if (options.data != null) {
          _log('Raw request body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (Response<dynamic> res, ResponseInterceptorHandler handler) {
        _log(
          'Got response from: ${res.requestOptions.uri} ${res.statusCode}',
        );
        _log('Raw response body: ${res.data}');
        dynamic resolvedData;
        if (res.statusCode == HttpStatus.noContent) {
          resolvedData = _successModel().toJson();
        } else {
          final dynamic data = res.data;
          if (data is String) {
            try {
              // If we do want a JSON all the time, DO try to decode the data.
              resolvedData = jsonDecode(data) as Json?;
            } catch (e) {
              resolvedData = data;
            }
          } else {
            resolvedData = data;
          }
        }
        res.data = resolvedData;
        handler.resolve(res);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        DioException error = e;
        if (error.type == DioExceptionType.cancel) {
          error = error.copyWith(
            response: error.response ??
                Response<Json>(
                  requestOptions: error.requestOptions,
                  data: _cancelledModel(
                    error.message,
                    error.requestOptions.uri.toString(),
                  ).toJson(),
                ),
          );
          handler.resolve(error.response!);
          return;
        }
        if (kDebugMode) {
          _log(error, stackTrace: error.stackTrace, isError: true);
        }
        final bool isConnectionTimeout =
            error.type == DioExceptionType.connectionTimeout;
        final bool isStatusError = error.response != null &&
            error.response!.statusCode != null &&
            error.response!.statusCode! >= HttpStatus.internalServerError;
        if (!isConnectionTimeout && isStatusError) {
          _log(
            'Error when requesting ${error.requestOptions.uri}\n'
            '$error\n'
            'Raw response data: ${error.response?.data}',
            isError: true,
          );
        }
        if (error.response?.data is String) {
          error.response!.data = _failModel(
            error.response!.data! as String,
          ).toJson();
        }
        error = error.copyWith(
          response: error.response ??
              Response<Json>(
                requestOptions: e.requestOptions,
                data: _failModel(e.message).toJson(),
              ),
        );
        e.response!.data ??= _failModel(e.message).toJson();
        handler.resolve(e.response!);
      },
    );
  }
}
