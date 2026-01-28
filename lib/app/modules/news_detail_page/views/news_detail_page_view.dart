import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../controllers/news_detail_page_controller.dart';

class NewsDetailPageView extends GetView<NewsDetailPageController> {
  const NewsDetailPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Informasi Personalia'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.save_2_copy),
            ),
          ],
          elevation: 0,
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 1 / 0.6,
              child: Container(
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    'Olahraga Elektronik: Fenomena Baru di Kalangan Generasi Muda',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Gap(20),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: '',
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/logo/logo.png'),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Text(
                        'Admin Personalia',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '2 jam yang lalu',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  const Gap(10),
                  Text(
                    '''Olahraga elektronik atau e-sports semakin populer di kalangan generasi muda. Dengan turnamen yang menawarkan hadiah besar dan penggemar yang terus bertambah, banyak pemain muda yang bermimpi untuk menjadi profesional. Beberapa universitas bahkan mulai menawarkan beasiswa untuk atlet e-sports.

Anda dapat menggunakan contoh-contoh di atas sebagai referensi atau mengeditnya sesuai kebutuhan Anda. Jika Anda memerlukan lebih banyak contoh atau tema tertentu, silakan beri tahu!''',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
