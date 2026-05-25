import '../tools/tool_call.dart';
import 'llm_finish_reason.dart';
import 'llm_usage.dart';

class LlmResponse {
  final String id;
  final String content;
  final LlmFinishReason finishReason;
  final List<ToolCall>? toolCalls;
  final LlmUsage usage;

  LlmResponse({required this.id, required this.content, required this.finishReason, required this.toolCalls, required this.usage});
}
