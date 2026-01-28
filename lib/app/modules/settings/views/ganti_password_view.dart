import 'package:lancar_cat/app/shared/loading/loading1.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/shared/button/button_1.dart';
import 'package:lancar_cat/app/shared/snackbar/snackbar_1.dart';
import 'package:lancar_cat/app/shared/textfield/textfield_1.dart';
import 'package:lancar_cat/app/shared/utils.dart';

import '../../../controllers/api_controller.dart';

class ChangePasswordView extends StatefulWidget {
  ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final a = Get.put(ApiController());

  final oldPasswordC = TextEditingController();

  final newPasswordC = TextEditingController();

  final confirmPasswordC = TextEditingController();

  bool oldP = true;
  bool newP = true;
  bool confirmP = true;

  @override
  void dispose() {
    // make dispose textfield
    oldPasswordC.dispose();
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(title: const Text('Ubah Kata Sandi'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField1(
              isTextShowing: true,
              controller: oldPasswordC,
              maxLines: 1,
              obsecure: oldP,
              hintText: 'Password lama',
              requiredLabel: 'min: 8 karakter',
              preffixIcon: Icon(Iconsax.lock_1, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    oldP = !oldP;
                  });
                },
                child: oldP
                    ? Icon(Iconsax.eye_slash, color: Colors.grey, size: 20)
                    : Icon(Iconsax.eye, color: Colors.grey, size: 20),
              ),
            ),
            const SizedBox(height: 5),
            TextField1(
              isTextShowing: true,
              controller: newPasswordC,
              maxLines: 1,
              obsecure: newP,
              requiredLabel: 'min: 8 karakter',
              hintText: 'Password baru',
              preffixIcon: Icon(Iconsax.lock_1, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    newP = !newP;
                  });
                },
                child: newP
                    ? Icon(Iconsax.eye_slash, color: Colors.grey, size: 20)
                    : Icon(Iconsax.eye, color: Colors.grey, size: 20),
              ),
            ),
            const SizedBox(height: 5),
            TextField1(
              isTextShowing: true,
              controller: confirmPasswordC,
              maxLines: 1,
              obsecure: confirmP,
              requiredLabel: 'min: 8 karakter',
              hintText: 'Konfirmasi password',
              preffixIcon: Icon(Iconsax.lock_1, color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    confirmP = !confirmP;
                  });
                },
                child: confirmP
                    ? Icon(Iconsax.eye_slash, color: Colors.grey, size: 20)
                    : Icon(Iconsax.eye, color: Colors.grey, size: 20),
              ),
            ),
            const Spacer(),
            Button1(title: 'Ubah Kata Sandi', onTap: _onPressed),
          ],
        ),
      ),
    );
  }

  _onPressed() async {
    if (oldPasswordC.text.isEmpty) {
      Snackbar().snackbar1(
        'Informasi',
        'Password lama tidak boleh kosong.',
        Iconsax.info_circle,
        Colors.white,
        Colors.red.shade400,
      );
      return;
    }

    if (newPasswordC.text.isEmpty && confirmPasswordC.text.isEmpty) {
      Snackbar().snackbar1(
        'Informasi',
        'Password baru tidak boleh kosong.',
        Iconsax.info_circle,
        Colors.white,
        Colors.red.shade400,
      );
      return;
    }

    if (newPasswordC.text != confirmPasswordC.text) {
      Snackbar().snackbar1(
        'Informasi',
        'Password baru tidak sama.',
        Iconsax.info_circle,
        Colors.white,
        Colors.red.shade400,
      );
      return;
    }

    Get.dialog(Loading1());
    await a
        .changePassword(
          oldPassword: oldPasswordC.text,
          newPassword: newPasswordC.text,
          confirmPassword: confirmPasswordC.text,
        )
        .timeout(
          const Duration(seconds: 6),
          onTimeout: () {
            Get.back();
            Snackbar().snackbar1(
              'Informasi',
              'Terjadi kesalahan, silahkan coba kembali',
              Iconsax.lock,
              Colors.white,
              redColor,
            );
          },
        )
        .then((value) {
          if (value) {
            Get.back();
            Get.back();
            Snackbar().snackbar1(
              'Berhasil',
              'Password anda telah diubah',
              Iconsax.check,
              Colors.white,
              greenColor,
            );
          }
        });
  }
}
