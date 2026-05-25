import 'dart:math';

/// Базовый класс всех событий AlteriOne.
abstract class AlteriOneEvent {
  final String id;
  final DateTime timestamp;

  AlteriOneEvent() : id = _generateId(), timestamp = DateTime.now();

  String get type;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() =>
      'AlteriOneEvent($type @ ${timestamp.millisecondsSinceEpoch})';

  static String _generateId() {
    final rand = Random.secure();
    final bytes = List<int>.generate(8, (_) => rand.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
