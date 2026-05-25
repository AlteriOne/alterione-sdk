import '../plugin/alterione_plugin.dart';
import 'llm_chunk.dart';
import 'llm_request.dart';
import 'llm_response.dart';

abstract interface class AlteriOneLlmProvider implements AlteriOnePlugin {
  Future<LlmResponse> complete(LlmRequest request);
  Stream<LlmChunk> stream(LlmRequest request);
}
