import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/auth_controller.dart';
import 'package:quiz_app/controllers/theme_controller.dart';
import 'package:quiz_app/services/firebase_storage_services.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => FirebaseStorageServices());
  }
}
