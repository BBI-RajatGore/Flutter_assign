import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Constants {
  
  static final List<String> imageUrls = [
    'https://sketchok.com/images/articles/06-anime/002-one-piece/26/16.jpg',
    'https://imgcdn.stablediffusionweb.com/2024/9/14/fb1914b4-e462-4741-b25d-6e55eeeacd0c.jpg',
    'https://preview.redd.it/my-boa-hancock-attempt-v0-30ze1pt9g58c1.png?width=1280&format=png&auto=webp&s=31933400f61edfcd2007e6949af56e24d0522c07',
    'https://imgcdn.stablediffusionweb.com/2024/10/7/16f5e32e-0833-425f-9c2a-6c07aae8c5ee.jpg',
    'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/040dc617-5ca2-49ad-9518-65fd6ac1e816/anim=false,width=450/00218-2389552877.jpeg',
    'https://i.pinimg.com/564x/78/fc/26/78fc26efc924e11c992afcf80c966a0f.jpg',
    'https://wallpapers.com/images/hd/anime-girl-profile-pictures-kr6trv4dmtrqrbez.jpg',
    'https://img.freepik.com/free-vector/young-man-with-glasses-avatar_1308-175763.jpg?t=st=1737359102~exp=1737362702~hmac=cf0e40c06d9f4e9c6ea250b792651bbde1673760167ac5215a93c7f85264f3e5&w=740',
  ];

  static showSuccessSnackBar(BuildContext context, String msg) {
    return showTopSnackBar(
      displayDuration: const Duration(milliseconds: 3),
      Overlay.of(context),
      CustomSnackBar.success(
        backgroundColor: Colors.teal,
        message: msg,
      ),
    );
  }


  static showErrorSnackBar(BuildContext context, String msg) {
    return showTopSnackBar(
      displayDuration: const Duration(milliseconds: 3),
      Overlay.of(context),
      CustomSnackBar.error(
        message: msg,
      ),
    );
  }
}
