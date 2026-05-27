import 'package:get/get.dart';
import 'add_chime_controller.dart';

class AddChimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddChimeController>(() => AddChimeController());
  }
}
