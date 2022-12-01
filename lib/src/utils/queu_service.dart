import 'package:queue/queue.dart';

/// The [QueueService] class is a wrapper around the [Queue] class.
class QueueService {
  /// The [Queue] instance.
  QueueService();

  /// The unique [Queue] instance.
  final queues = <Object, Queue>{};

  /// Returns the computation for the [process] while keeping it queued.
  Future<T> addToQueue<T>(Object uniqueId, Future<T> Function() process) async {
    final userHasAnExistingQueue = queues.containsKey(uniqueId);
    if (!userHasAnExistingQueue) {
      queues[uniqueId] = Queue();
    }
    final queue = queues[uniqueId];
    return queue!.add(process);
  }

  /// Clears the [Queue]s.
  void dispose() => queues.clear();
}
