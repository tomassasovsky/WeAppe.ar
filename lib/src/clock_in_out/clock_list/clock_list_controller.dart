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
    final result = await Services().clockInOuts.getListByUserId(
          userId: userId,
          qty: qty,
          from: from,
          to: to,
        );
    res.statusCode = 200;
    await res
        .json(result?.map((e) => e.toJson(standardEncoding: true)).toList());
  }

  @override
  ClockListController get newInstance => ClockListController();
}
