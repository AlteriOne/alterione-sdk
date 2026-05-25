import 'memory_type.dart';

class MemoryEntry {
  final String id;
  final String personaId;
  final MemoryType type;
  final String content;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<double>? embedding; // для semantic memory
  final double? relevanceScore; // устанавливается при recall, не хранится

  const MemoryEntry({
    required this.id,
    required this.personaId,
    required this.type,
    required this.content,
    this.metadata = const {},
    required this.createdAt,
    this.expiresAt,
    this.embedding,
    this.relevanceScore,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  MemoryEntry withScore(double score) => MemoryEntry(
    id: id,
    personaId: personaId,
    type: type,
    content: content,
    metadata: metadata,
    createdAt: createdAt,
    expiresAt: expiresAt,
    embedding: embedding,
    relevanceScore: score,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'persona_id': personaId,
    'type': type.name,
    'content': content,
    'metadata': metadata,
    'created_at': createdAt.toIso8601String(),
    if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
  };

  factory MemoryEntry.fromJson(Map<String, dynamic> json) => MemoryEntry(
    id: json['id'] as String,
    personaId: json['persona_id'] as String,
    type: MemoryType.values.byName(json['type'] as String),
    content: json['content'] as String,
    metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? {},
    createdAt: DateTime.parse(json['created_at'] as String),
    expiresAt: json['expires_at'] != null
        ? DateTime.parse(json['expires_at'] as String)
        : null,
  );
}
