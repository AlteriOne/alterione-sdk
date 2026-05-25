import 'mcp_error.dart';

class McpMessage {
  static const _jsonrpc = '2.0';

  final dynamic id; // String | int | null
  final String? method; // только в requests
  final Map<String, dynamic>? params;
  final dynamic result; // только в responses
  final McpError? error;

  const McpMessage._({
    this.id,
    this.method,
    this.params,
    this.result,
    this.error,
  });

  factory McpMessage.request(
    dynamic id,
    String method, [
    Map<String, dynamic>? params,
  ]) => McpMessage._(id: id, method: method, params: params);

  factory McpMessage.notification(
    String method, [
    Map<String, dynamic>? params,
  ]) => McpMessage._(method: method, params: params);

  factory McpMessage.result(dynamic id, dynamic result) =>
      McpMessage._(id: id, result: result);

  factory McpMessage.error(
    dynamic id,
    int code,
    String message, [
    dynamic data,
  ]) => McpMessage._(
    id: id,
    error: McpError(code: code, message: message, data: data),
  );

  bool get isRequest => method != null && id != null;
  bool get isNotification => method != null && id == null;
  bool get isResult => result != null && method == null;
  bool get isError => error != null;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'jsonrpc': _jsonrpc};
    if (id != null) json['id'] = id;
    if (method != null) json['method'] = method;
    if (params != null) json['params'] = params;
    if (result != null) json['result'] = result;
    if (error != null) json['error'] = error!.toJson();
    return json;
  }

  factory McpMessage.fromJson(Map<String, dynamic> json) => McpMessage._(
    id: json['id'],
    method: json['method'] as String?,
    params: (json['params'] as Map?)?.cast<String, dynamic>(),
    result: json['result'],
    error: json['error'] != null
        ? McpError.fromJson(json['error'] as Map<String, dynamic>)
        : null,
  );
}
