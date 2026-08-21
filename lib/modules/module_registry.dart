import '../core/sign_bro_module.dart';
import 'crm/crm_page.dart';
import 'ar/ar_page.dart';
import 'drone/drone_page.dart';
import 'led/smart_led_page.dart';
import 'future/future_lab_page.dart';
import 'admin/admin_module.dart';
import 'streetview/street_view_scanner.dart';

class ModuleRegistry {
  static List<SignBroModule> modules = [
    CRMModule(),
    ARModule(),
    DroneModule(),
    SmartLEDModule(),
    FutureLabModule(),
    AdminModule(),
    StreetViewModule(),
  ];
}
