import 'package:shelf/shelf.dart';
import 'package:weappear_backend/src/controller.dart';
import 'package:weappear_backend/src/services/record_service.dart';
import 'package:weappear_backend/src/utils/utils.dart';

class RecordsController extends Controller {
  RecordsController() {
    final service = RecordService();
    router.mount(
      path,
      Pipeline().addMiddleware(Middlewares.tokenMiddleware).addHandler(
            router..post('/clockIn', service.clockIn),
          ),
    );
  }

  @override
  String get path => '/records';
}
