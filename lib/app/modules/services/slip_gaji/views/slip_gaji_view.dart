import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/controllers/model_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';
import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/textfield/textfield_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

class SlipGajiView extends StatefulWidget {
  const SlipGajiView({Key? key}) : super(key: key);

  @override
  State<SlipGajiView> createState() => _SlipGajiViewState();
}

class _SlipGajiViewState extends State<SlipGajiView> {
  RxBool isObsecure = true.obs;
  RxBool isFalse = false.obs;
  final a = Get.put(ApiController());
  final m = Get.find<ModelController>();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _showDialogPassword();
    });
  }

  Future checkPassword() async {
    Uri url = Uri.parse('${Variables.baseUrl}/v2/user/check-password');

    try {
      final response = await http.post(
        url,
        body: {'password': password.text},
        headers: {'Authorization': 'Bearer ${m.token.value}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool status = data['status'];
        isFalse(!status);
        return status;
      }
    } on HttpException catch (e) {
      Get.dialog(AlertDialog(content: Text(e.message)));
    } catch (e) {
      Get.dialog(AlertDialog(content: Text("$e")));
    }
  }

  _showDialogPassword() {
    Get.dialog(
      AlertDialog(
        title: Text('Password', style: TextStyle(fontSize: 16)),
        content: Wrap(
          children: [
            Obx(
              () => TextField1(
                controller: password,
                hintText: 'Masukan Password',
                obsecure: isObsecure.value,
                maxLines: 1,
                suffixIcon: IconButton(
                  onPressed: () {
                    print('on tap');
                    setState(() {
                      isObsecure.value = !isObsecure.value;
                    });
                  },
                  icon: Icon(
                    isObsecure.value
                        ? Iconsax.eye_slash_copy
                        : Iconsax.eye_copy,
                  ),
                ),
                preffixIcon: Icon(Iconsax.lock_1_copy),
              ),
            ),
            Obx(
              () => (!isFalse.value)
                  ? SizedBox()
                  : Text(
                      'Password salah, harap cek dan masukkan kembali',
                      style: TextStyle(color: redColor, fontSize: 12),
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: Get.width,
              child: Button1(
                title: 'Kirim',
                onTap: () async {
                  await checkPassword().then((value) {
                    if (value) {
                      Get.back();
                      // jalankan pemanggilan payroll
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(title: const Text('Slip Gaji'), centerTitle: true),
      body: Center(
        child: Text('SlipGajiView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
