import '../tools/tool_call.dart';
import 'llm_role.dart';

class LlmMessage {
  final LlmRole role;
  final String? content;
  final String? name;
  final List<ToolCall>? toolCalls; // для assistant — запросы инструментов
  final String? toolCallId; // для tool — ID вызова которому отвечаем

  const LlmMessage._({
    required this.role,
    this.content,
    this.name,
    this.toolCalls,
    this.toolCallId,
  });

  factory LlmMessage.system(String content) =>
      LlmMessage._(role: LlmRole.system, content: content);

  factory LlmMessage.user(String content, {String? name}) =>
      LlmMessage._(role: LlmRole.user, content: content, name: name);

  factory LlmMessage.assistant(String content, {List<ToolCall>? toolCalls}) =>
      LlmMessage._(
        role: LlmRole.assistant,
        content: content,
        toolCalls: toolCalls,
      );

  factory LlmMessage.toolResult(String toolCallId, String content) =>
      LlmMessage._(
        role: LlmRole.tool,
        content: content,
        toolCallId: toolCallId,
      );

  /// OpenAI-совместимый формат
  Map<String, dynamic> toOpenAiJson() {
    final json = <String, dynamic>{'role': role.value};
    if (content != null) json['content'] = content;
    if (name != null) json['name'] = name;
    if (toolCallId != null) json['tool_call_id'] = toolCallId;
    if (toolCalls != null) {
      json['tool_calls'] = toolCalls!.map((tc) => tc.toJson()).toList();
    }
    return json;
  }

  factory LlmMessage.fromOpenAiJson(Map<String, dynamic> json) => LlmMessage._(
    role: LlmRole.fromValue(json['role'] as String),
    content: json['content'] as String?,
    name: json['name'] as String?,
    toolCallId: json['tool_call_id'] as String?,
    toolCalls: (json['tool_calls'] as List?)
        ?.map((tc) => ToolCall.fromJson(tc as Map<String, dynamic>))
        .toList(),
  );
}
