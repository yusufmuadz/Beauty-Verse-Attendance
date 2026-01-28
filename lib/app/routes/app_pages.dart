import 'package:get/get.dart';

import '../modules/subordinate/bindings/subordinate_binding.dart';
import '../modules/subordinate/views/subordinate_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/camera_capture/bindings/camera_capture_binding.dart';
import '../modules/camera_capture/views/camera_capture_view.dart';
import '../modules/detail_information_employee/bindings/detail_information_employee_binding.dart';
import '../modules/detail_information_employee/views/detail_information_employee_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/menu_view.dart';
import '../modules/locations_tracker/bindings/locations_tracker_binding.dart';
import '../modules/locations_tracker/views/locations_tracker_view.dart';
import '../modules/news_detail_page/bindings/news_detail_page_binding.dart';
import '../modules/news_detail_page/views/news_detail_page_view.dart';
import '../modules/permintaan/bindings/permintaan_binding.dart';
import '../modules/permintaan/views/permintaan_view.dart';
import '../modules/services/istirahat_telat/bindings/istirahat_telat_binding.dart';
import '../modules/services/istirahat_telat/views/istirahat_telat_view.dart';
import '../modules/services/lembur/bindings/lembur_binding.dart';
import '../modules/services/lembur/views/history_lembur_view.dart';
import '../modules/services/team_members/bindings/team_members_binding.dart';
import '../modules/services/team_members/views/team_members_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => MenuView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: () => const AuthenticationView(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA_CAPTURE,
      page: () => CameraCaptureView(),
      binding: CameraCaptureBinding(),
    ),
    GetPage(
      name: _Paths.LOCATIONS_TRACKER,
      page: () => LocationsTrackerView(),
      binding: LocationsTrackerBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.TEAM_MEMBERS,
      page: () => TeamMembersView(),
      binding: TeamMembersBinding(),
    ),
    GetPage(
      name: _Paths.LEMBUR,
      page: () => LemburView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: _Paths.ISTIRAHAT_TELAT,
      page: () => IstirahatTelatView(),
      binding: IstirahatTelatBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL_PAGE,
      page: () => const NewsDetailPageView(),
      binding: NewsDetailPageBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_INFORMATION_EMPLOYEE,
      page: () => const DetailInformationEmployeeView(),
      binding: DetailInformationEmployeeBinding(),
    ),
    GetPage(
      name: _Paths.PERMINTAAN,
      page: () => const PermintaanView(),
      binding: PermintaanBinding(),
    ),
    GetPage(
      name: _Paths.SUBORDINATE,
      page: () => const SubordinateView(),
      binding: SubordinateBinding(),
    ),
  ];
}
