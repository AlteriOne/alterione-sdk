import 'dart:async';

import 'alterione_event.dart';

/// Шина событий на основе Dart Streams — без зависимостей.
class EventBus {
  final _controller = StreamController<AlteriOneEvent>.broadcast();
  bool _disposed = false;

  void fire(AlteriOneEvent event) {
    if (_disposed) return;
    _controller.add(event);
  }

  /// Подписка на конкретный тип события
  Stream<T> on<T extends AlteriOneEvent>() =>
      _controller.stream.where((event) => event is T).cast<T>();

  /// Подписка с автоматической отменой
  StreamSubscription<T> listen<T extends AlteriOneEvent>(
    void Function(T event) handler, {
    void Function(Object error)? onError,
  }) => on<T>().listen(handler, onError: onError);

  /// Одноразовое ожидание события
  Future<T> waitFor<T extends AlteriOneEvent>({Duration? timeout}) {
    final future = on<T>().first;
    return timeout != null ? future.timeout(timeout) : future;
  }

  bool get isDisposed => _disposed;

  Future<void> dispose() async {
    _disposed = true;
    await _controller.close();
  }
}
