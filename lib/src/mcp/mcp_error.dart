class McpError {
  final int code;
  final String message;
  final dynamic data;

  // Стандартные коды JSON-RPC
  static const parseError = -32700;
  static const invalidRequest = -32600;
  static const methodNotFound = -32601;
  static const invalidParams = -32602;
  static const internalError = -32603;

  const McpError({required this.code, required this.message, this.data});

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    if (data != null) 'data': data,
  };

  factory McpError.fromJson(Map<String, dynamic> json) => McpError(
    code: json['code'] as int,
    message: json['message'] as String,
    data: json['data'],
  );
}
