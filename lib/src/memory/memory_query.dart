import 'memory_type.dart';

class MemoryQuery {
  final String personaId;
  final List<MemoryType> types;
  final String? text;
  final List<double>? embedding;
  final int limit;
  final DateTime? from;
  final DateTime? to;
  final Map<String, dynamic> filters;

  const MemoryQuery({
    required this.personaId,
    this.types = MemoryType.values,
    this.text,
    this.embedding,
    this.limit = 10,
    this.from,
    this.to,
    this.filters = const {},
  });
}
