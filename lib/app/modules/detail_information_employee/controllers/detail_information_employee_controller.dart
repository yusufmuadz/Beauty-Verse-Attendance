import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../controllers/model_controller.dart';
import '../../../core/constant/variables.dart';
import '../../../models/leave.dart';
import '../../../models/profile_response_model.dart';

class DetailInformationEmployeeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onInit() async {
    super.onInit();
    idEmployee = Get.arguments as String;
    profileResponseModel = ProfileResponseModel();
    tabController = TabController(length: 2, vsync: this);
    await getProfileInformation().then((value) => isLoading(false));
    temp.value = DateFormat('yyyy-MM').format(
      DateTime.parse(
        '${DateTime.now().year}-${monthFormatted(DateTime.now().month)}-${DateTime.now().day}',
      ),
    );
  }

  @override
  void onClose() {
    isLoading(true);
    super.onClose();
  }

  final search = TextEditingController();
  int monthPicker = DateTime.now().month;
  int yearPicker = DateTime.now().year;
  RxString temp = ''.obs;
  late String idEmployee;
  late TabController tabController;
  final controller = Get.find<ModelController>();
  late ProfileResponseModel profileResponseModel;
  RxBool isLoading = true.obs;
  RxString imgUrl = ''.obs;

  Object monthFormatted(int month) => (month < 10) ? "0$month" : month;

  Future getProfileInformation() async {
    try {
      var headers = {'Authorization': 'Bearer ${controller.token.value}'};

      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/user/detail/$idEmployee'),
      );

      debugPrint('log_info: $idEmployee => ${request.url}');

      debugPrint('log_info: $idEmployee => ${request.headers}');

      debugPrint('log_info: $idEmployee => ${request.method}');

      debugPrint('log_info: $idEmployee => ${request.body}');

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        debugPrint('log_info: $idEmployee => response success');
        debugPrint('log_info: $idEmployee => ${response.statusCode}');
        final data = await response.stream.bytesToString();
        debugPrint('log_info: $idEmployee => ${data}');
        final result = ProfileResponseModel.fromJson(data);
        profileResponseModel = result;
        imgUrl(profileResponseModel.data!.person!.informasiPribadi!.imageUrl);
      } else {
        debugPrint(response.reasonPhrase);
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ResponseModelLeave?> fetchLeaveEmployeeById({
    required String targetId,
    required String monthSelected,
  }) async {
    var headers = {'Authorization': 'Bearer ${controller.token.value}'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '${Variables.baseUrl}/leaves/user?id_user=$targetId&month_selected=$monthSelected',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    debugPrint(
      'log_info: $targetId, month_selected: $monthSelected => ${response.statusCode}',
    );
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final result = ResponseModelLeave.fromJson(str);
      return result;
    } else {
      return null;
    }
  }
}
