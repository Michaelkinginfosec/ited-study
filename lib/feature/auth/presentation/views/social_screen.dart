import 'package:flutter/material.dart';
import 'package:ited_study/core/utils/url_laucher.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Our Socials",
              style: TextStyle(
                color: Color.fromRGBO(15, 6, 94, 1),
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Follow us on our social medial handles',
              style: TextStyle(
                color: Color.fromRGBO(181, 178, 178, 1),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () => UrlLaucher().openFacebook(context),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.grey,
                elevation: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/facebook.png",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "itededucationalsoftwares@facebook.com",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => UrlLaucher().openInstagram(context),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.grey,
                elevation: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/instagram.png",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "itededucationalsoftwares@instagram.com",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                UrlLaucher().openTiktok(context);
              },
              child: Material(
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.grey,
                elevation: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/tiktok.png",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "itededucationalsoftwares@tiktok.com",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                UrlLaucher().openTelegram(context);
              },
              child: Material(
                borderRadius: BorderRadius.circular(10),
                shadowColor: Colors.grey,
                elevation: 1,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/telegram.png",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "itededucationalsoftwares@telegram.com",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
