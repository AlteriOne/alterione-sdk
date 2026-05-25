import '../tools/tool_call.dart';

class LlmChunk {
  final String delta; // токен
  final bool isDone;
  final ToolCall? toolCallDelta;

  LlmChunk({required this.delta, required this.isDone, required this.toolCallDelta});
}
