import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/record_service.dart';
import 'package:weappear_backend/src/utils/utils.dart';

/// {@template records_controller}
/// This controller has all the routes for the records collection.
/// {@endtemplate}
class RecordsController extends Controller {
  /// {@macro records_controller}
  RecordsController() {
    final service = RecordService();
    router.mount(
      path,
      addMiddleWares(
        router
          ..post('/clockIn', service.clockIn)
          ..post('/clockOut', service.clockOut)
          ..post('/createRecord', service.createRecord)
          ..get('/', service.getRecords),
        [Middlewares.tokenMiddleware],
      ),
    );
  }

  @override
  String get path => '/records';
}
