import '../plugin/alterione_plugin.dart';
import 'memory_entry.dart';
import 'memory_query.dart';

abstract interface class AlteriOneMemoryStore implements AlteriOnePlugin {
  Future<void> store(MemoryEntry entry);
  Future<List<MemoryEntry>> recall(MemoryQuery query);
  Future<void> forget(String entryId);
}
