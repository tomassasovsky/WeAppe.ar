part of 'clock_list.dart';

class ClockListController extends Controller<ClockListController> {
  late final ObjectId userId;
  late final int qty;
  late final Timestamp from;
  late final Timestamp to;
  String? organizationId;

  @override
  FutureOr<void> defineVars(HttpRequest req, HttpResponse res) async {
    userId = req.store.get<ObjectId>('userId');
    organizationId = req.store.tryGet<String>('organizationId');
    qty = req.store.get<int>('qty');
    from = req.store.get<Timestamp>('from');
    to = req.store.get<Timestamp>('to');
  }

  @override
  FutureOr<dynamic> run(HttpRequest req, HttpResponse res) async {
    final selector = where
      ..eq('userId', userId)
      ..gte('clockIn', from)
      ..lte('clockOut', to)
      ..sortBy('clockIn', descending: true)
      ..limit(qty);

    if (organizationId != null) {
      selector..eq('organizationId', organizationId);
    }

    final result = await LoggedTime.generic.find(selector);

    res.statusCode = 200;
    await res.json(result
        .map((loggedTime) => loggedTime.toJson(standardEncoding: true))
        .toList());
  }

  @override
  ClockListController get newInstance => ClockListController();
}
