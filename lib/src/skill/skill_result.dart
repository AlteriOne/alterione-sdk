import 'dart:convert';

class SkillResult {
  final String callId;
  final bool success;
  final dynamic data;
  final String? error;
  final Duration duration;

  const SkillResult({
    required this.callId,
    required this.success,
    required this.duration,
    this.data,
    this.error,
  });

  factory SkillResult.ok(String callId, dynamic data, Duration duration) =>
      SkillResult(
        callId: callId,
        success: true,
        data: data,
        duration: duration,
      );

  factory SkillResult.err(String callId, String error, Duration duration) =>
      SkillResult(
        callId: callId,
        success: false,
        error: error,
        duration: duration,
      );

  /// Строка для передачи обратно в LLM
  String toContentString() {
    if (!success) return 'Error: $error';
    if (data is String) return data as String;
    return jsonEncode(data);
  }
}
