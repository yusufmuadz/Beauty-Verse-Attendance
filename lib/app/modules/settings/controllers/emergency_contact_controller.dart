import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/model_controller.dart';
import '../../../core/constant/variables.dart';
import '../../../data/model/emergency_contact_response_model.dart';

class EmergencyContactController {
  final m = Get.find<ModelController>();

  // fetch options contact relations
  Future fetchOptionsContactRelations() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/user/hubungan/list'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final List<String> relationships = json.decode(data).cast<String>();
        return relationships;
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } on HttpException catch (e) {
      Get.dialog(AlertDialog(title: Text(e.message)));
    }
  }

  // get emergency contact
  Future storeEmergencyContact({
    required String nama,
    required String hubungan,
    required String notelp,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${m.token.value}',
    };
    var request = http.Request(
      'POST',
      Uri.parse('${Variables.baseUrl}/v1/user/emergency-contact'),
    );
    request.body = json.encode({
      "nama": nama,
      "hubungan": hubungan,
      "notelp": notelp,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // debugPrint(await response.stream.bytesToString());
    } else {
      debugPrint('${response.reasonPhrase}');
    }
  }

  // delete emergency contact
  Future deleteEmergencyContact({required int id}) async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'DELETE',
        Uri.parse('${Variables.baseUrl}/v1/user/emergency-contact/$id'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // debugPrint(await response.stream.bytesToString());
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } catch (e) {
      Get.dialog(AlertDialog(title: Text(e.toString())));
    }
  }

  // update emergency contact
  Future updateEmergencyContact({
    required int id,
    required String nama,
    required String hubungan,
    required String notelp,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${m.token.value}',
      };
      var request = http.Request(
        'POST',
        Uri.parse('${Variables.baseUrl}/v1/user/emergency-contact/$id'),
      );

      request.body = json.encode({
        "nama": nama,
        "hubungan": hubungan,
        "notelp": notelp,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } on HttpException catch (e) {
      Get.dialog(AlertDialog(title: Text(e.message)));
    }
  }

  // fetch emergency contact
  Future fetchEmergencyContact() async {
    try {
      var headers = {'Authorization': 'Bearer ${m.token.value}'};
      var request = http.Request(
        'GET',
        Uri.parse('${Variables.baseUrl}/v1/user/emergency-contact'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = EmergencyContactResponseModel.fromJson(
          await response.stream.bytesToString(),
        );
        log(data.toJson());
        return data;
      } else {
        debugPrint('${response.reasonPhrase}');
      }
    } on HttpException catch (e) {
      Get.dialog(AlertDialog(title: Text(e.message)));
    }
  }
}
