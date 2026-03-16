import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../controllers/api_controller.dart';
import '../../../core/components/my_button.dart';
import '../../../core/components/my_textfield.dart';
import '../../../core/constant/variables.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formAuth = GlobalKey<FormState>();

  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  final email = TextEditingController();
  final password = TextEditingController();

  final a = Get.put(ApiController());

  RxBool obsecure = true.obs;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(color: Colors.amber.shade900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          Variables.logoPath,
                          width: 90,
                          height: 120,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.figtree(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Masuk menggunakan akun yang sudah di daftarkan',
                            style: GoogleFonts.figtree(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
              const Gap(15),
              Form(
                key: _formAuth,
                child: Column(
                  children: [
                    MyTextfield(
                      controller: _emailC,
                      hintText: 'Email',
                      showTxt: true,
                      obsecure: false,
                      keyboardType: TextInputType.emailAddress,
                      prefix: Icon(Iconsax.sms_copy, color: Colors.grey),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Tidak Boleh Kosong';
                        } else if (!value.contains('@')) {
                          return 'Format Email Salah';
                        }
                        return null;
                      },
                    ),
                    const Gap(10),
                    Obx(
                      () => MyTextfield(
                        showTxt: true,
                        controller: _passC,
                        hintText: 'Password',
                        obsecure: obsecure.value,
                        prefix: Icon(Iconsax.lock_copy, color: Colors.grey),
                        suffix: IconButton(
                          onPressed: () => obsecure.value = !obsecure.value,
                          icon: Icon(
                            obsecure.value
                                ? Iconsax.eye_slash_copy
                                : Iconsax.eye_copy,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password tidak boleh kosong';
                          } else if (value.length < 8) {
                            return 'Password minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lupa Password?',
                      style: GoogleFonts.outfit(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.amber,
                        color: Colors.amber,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(30),
              MyButton(txtBtn: 'Login', onTap: _onPressed),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    if (_formAuth.currentState!.validate()) {
      Variables().loading();
      await a.login(email: _emailC.text, password: _passC.text);
    }
  }
}
