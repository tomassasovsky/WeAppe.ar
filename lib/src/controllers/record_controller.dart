import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/record_service.dart';

class RecordsController extends Controller {
  RecordsController() {
    final service = RecordService();
    router..post('$path/clockIn', service.clockIn);
  }

  @override
  String get path => '/records';
}
