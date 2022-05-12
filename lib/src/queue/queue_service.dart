import 'package:mongo_dart/mongo_dart.dart';
import 'package:queue/queue.dart';

class UserQueue {
  UserQueue();

  final userQueues = <ObjectId, Queue>{};

  Future<T> addToQueue<T>(ObjectId userId, Future<T> Function() process) async {
    final userHasAnExistingQueue = userQueues.containsKey(userId);
    if (!userHasAnExistingQueue) {
      userQueues[userId] = Queue();
    }
    final queue = userQueues[userId];
    return queue!.add(process);
  }

  void dispose() => userQueues.clear();
}
