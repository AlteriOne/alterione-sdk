import '../tools/tool_definition.dart';
import 'llm_message.dart';

class LlmRequest {
  final String model;
  final String systemPrompt;
  final List<LlmMessage> messages;
  final List<ToolDefinition> tools;
  final double temperature;
  final int maxTokens;
  final double topP;

  LlmRequest({required this.model, required this.systemPrompt, required this.messages, required this.tools, required this.temperature, required this.maxTokens, required this.topP});
}
