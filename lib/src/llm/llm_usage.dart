/// Статистика использования токенов от LLM.
class LlmUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final Duration? latency;
  final double? estimatedCostUsd;

  const LlmUsage({
    required this.promptTokens,
    required this.completionTokens,
    this.latency,
    this.estimatedCostUsd,
  }) : totalTokens = promptTokens + completionTokens;

  const LlmUsage.zero()
    : promptTokens = 0,
      completionTokens = 0,
      totalTokens = 0,
      latency = null,
      estimatedCostUsd = null;

  LlmUsage operator +(LlmUsage other) => LlmUsage(
    promptTokens: promptTokens + other.promptTokens,
    completionTokens: completionTokens + other.completionTokens,
    estimatedCostUsd: (estimatedCostUsd ?? 0) + (other.estimatedCostUsd ?? 0),
  );

  Map<String, dynamic> toJson() => {
    'prompt_tokens': promptTokens,
    'completion_tokens': completionTokens,
    'total_tokens': totalTokens,
    if (latency != null) 'latency_ms': latency!.inMilliseconds,
    if (estimatedCostUsd != null) 'estimated_cost_usd': estimatedCostUsd,
  };

  factory LlmUsage.fromJson(Map<String, dynamic> json) => LlmUsage(
    promptTokens: (json['prompt_tokens'] as int?) ?? 0,
    completionTokens: (json['completion_tokens'] as int?) ?? 0,
    estimatedCostUsd: (json['estimated_cost_usd'] as num?)?.toDouble(),
  );

  @override
  String toString() =>
      '${promptTokens}p + ${completionTokens}c = ${totalTokens}t';
}
