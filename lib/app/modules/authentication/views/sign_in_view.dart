import 'package:flutter/services.dart';
import 'package:lancar_cat/app/core/components/my_button.dart';
import 'package:lancar_cat/app/core/components/my_textfield.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:lancar_cat/app/controllers/api_controller.dart';
import 'package:lancar_cat/app/core/constant/variables.dart';

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
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
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
                    // SafeArea(
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [Image.asset(Variables.logoPath, height: 120)],
                    //   ),
                    // ),
                    SafeArea(
                      child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(Variables.logoPath, width: 90, height: 120),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Lupa Password?',
                    //     style: GoogleFonts.outfit(
                    //       decoration: TextDecoration.underline,
                    //       decorationColor: Colors.amber,
                    //       color: Colors.amber,
                    //       fontSize: 12,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Gap(30),
              MyButton(txtBtn: 'Login', onTap: _onPressed),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: HexColor("E5F7FF"),
    //   body: ListView(
    //     physics: BouncingScrollPhysics(),
    //     padding: const EdgeInsets.all(15),
    //     children: [
    //       SizedBox(height: context.height * 0.09),
    //       Image.asset(
    //         "assets/logo/logo.png",
    //         width: 150,
    //         height: 150,
    //       ),
    //       const SizedBox(height: 10),
    //       const Text(
    //         'Selamat Datang! Silahkan Login',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //       const SizedBox(height: 15),
    //       const Text(
    //         'Login menggunakan akun yang sudah didaftarkan oleh personalia',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           color: Colors.grey,
    //         ),
    //       ),
    //       Gap(context.height * 0.04),
    //       Form(
    //         key: _formAuth,
    //         child: Column(
    //           children: [
    //             TextfieldForm(
    //               controller: _emailC,
    //               hintText: "example@gmail.com",
    //               fillColor: Colors.white,
    //               filled: true,
    //               prefixIcon: Icon(Iconsax.user_copy),
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return 'Email tidak boleh kosong';
    //                 } else if (!value.contains('@')) {
    //                   return 'Email tidak valid';
    //                 }

    //                 return null;
    //               },
    //             ),
    //             const Gap(10),
    //             Obx(
    //               () => TextfieldForm(
    //                 prefixIcon: Icon(Iconsax.lock_copy),
    //                 controller: _passC,
    //                 hintText: "password",
    //                 fillColor: Colors.white,
    //                 obsecureText: obsecure.value,
    //                 keyboardType: TextInputType.visiblePassword,
    //                 filled: true,
    //                 suffixIcon: IconButton(
    //                   onPressed: () => obsecure.toggle(),
    //                   icon: Icon(
    //                     (obsecure.value)
    //                         ? Iconsax.eye_slash_copy
    //                         : Iconsax.eye_copy,
    //                     color: Colors.grey.shade500,
    //                   ),
    //                 ),
    //                 validator: (value) {
    //                   if (value!.isEmpty) {
    //                     return 'Password tidak boleh kosong';
    //                   } else if (value.length < 8) {
    //                     return 'Password minimal 8 karakter';
    //                   }
    //                   return null;
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       const Gap(15),
    //       Button1(title: "Log In", onTap: _onPressed),
    //       const Gap(15),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Divider(
    //               thickness: 1,
    //               color: Colors.grey.shade500,
    //             ),
    //           ),
    //           const Gap(10),
    //           const Text(
    //             "atau",
    //             style: TextStyle(
    //               fontSize: 12,
    //               color: Colors.grey,
    //             ),
    //           ),
    //           const Gap(10),
    //           Expanded(
    //             child: Divider(
    //               thickness: 1,
    //               color: Colors.grey.shade500,
    //             ),
    //           ),
    //         ],
    //       ),
    //       const Gap(15),
    //       Center(
    //         child: Text(
    //           'Belum memiliki akun?, Hubungi personalia.',
    //           style: TextStyle(
    //             fontSize: 12,
    //             fontWeight: FontWeight.normal,
    //             color: Colors.grey,
    //           ),
    //         ),
    //       ),
    //       const Gap(15),
    //       Button1(
    //         title: "Bantuan",
    //         onTap: () async {
    //           String formattedNumber = "+628112831859";
    //           Uri url = Uri.parse('https://wa.me/$formattedNumber');
    //           if (!await launchUrl(url)) {
    //             throw 'Could not launch $url';
    //           }
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  _onPressed() async {
    // cek apakah password kurang dari 8 char
    if (_formAuth.currentState!.validate()) {
      Variables().loading();
      await a.login(email: _emailC.text, password: _passC.text);
    }
  }
}
