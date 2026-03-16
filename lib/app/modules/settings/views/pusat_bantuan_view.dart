import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/model_controller.dart';
import '../../../shared/button/button_1.dart';

class PusatBantuanView extends StatelessWidget {
  PusatBantuanView({super.key});

  final m = Get.find<ModelController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * 1 -
                  MediaQuery.of(context).padding.left,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo ${m.u.value.nama!.split(' ')[0]}, ada yang bisa dibantu?',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Gap(10),
                  Text(
                    'Kamu bisa menanyakan topik yang kamu butuhkan.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/ic_help_desk.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const Gap(7.0),
                    Text(
                      'ADMIN PERSONALIA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Button1(
              title: 'Kirim Pertanyaan?',
              onTap: () async {
                String formattedNumber = "+628112831859";
                Uri url = Uri.parse('https://wa.me/$formattedNumber');
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
