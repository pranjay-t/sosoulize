import 'package:flutter/material.dart';
import 'package:sosoulize/Features/Home/app_bar_widget.dart/home_app_bar.dart';
import 'package:sosoulize/Features/Home/app_bar_widget.dart/add_post_app_bar.dart';
import 'package:sosoulize/Features/Home/app_bar_widget.dart/chat_app_bar.dart';
import 'package:sosoulize/Features/Home/app_bar_widget.dart/notification_app_bar.dart';
import 'package:sosoulize/Features/chat/screens/chat_screen.dart';
import 'package:sosoulize/Features/feeds/screens/feed_screen.dart';
import 'package:sosoulize/Features/notification/notification_screen.dart';
import 'package:sosoulize/Features/posts/screen/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginEmotePath = 'assets/images/login.png';
  static const googlePath = 'assets/images/google.png';

  static const bannerDefault =
      'https://media-hosting.imagekit.io//23c35ccfddc94aca/default_banner.jpeg?Expires=1736088681&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=Ul4PIXMd1seAicToaD1jtDaHnW~CGUxamQlRaGiIkEvxoKK3TQNYYHWZpfwsM2JPXo5UMj2BBVqDWAb6PeUf3Vc-U1i-tkGafXC99Ovua3qIShP1aY9KbwUyLd2-CwJW8bHOmORcrOg5ZkbYQV3DaDN1jSwSuOskqlayChb~in7M5TZkxWca2J1aa5EAmzqAKq5IyoIabD1uwuWRqtmauM44PHvwxP3MB5aUF7nyWXR8bbVMuaJuLEw2orzg~u6a7TUpCzBa-7VpLHrGbe0qReTzJMD6b~649ZaiclJCRXgeycU7CDQTk-pSL2kFgK-ZxRzzwNZZVALcpWikj3IjIg__';
  static const avatarDefault =
      'https://media-hosting.imagekit.io//b18cc8ad42504e5c/default_profile.jpeg?Expires=1736088108&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=rkZuZPRBx4K574ctXiFe~uEnejcRVOVW-wl9sPDtdkEby4U7KcBTvNhbHx~~mHDXe7E~8rgekoZtfIlHdft4XaxsMd1rdL4Q0XN-N2EYF9Ka8wy23r87Cys-qoYwBE6jhDCILoi1hDWI0dOhUHdwGU3Bdpv3m0SgZncYC5UEtLbZc2JNrt0gP52KfD0aDKtIXwQ~Ge94PfrzGMgndK1B8cB-kdZ4wJe36YX8RI~vk3SelBZ-jp63vRGzDwMopwEMPlMvRngM1K6XfBeLG~7DcWUnYjaw4~MQ7RBlOBVFezXOfk6RFeYWbgeRfbPSTWBJU8swnOc33mh1Alb6QDrJEA__';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
    ChatScreen(),
    NotificationScreen(),
  ];

  static final List<PreferredSizeWidget> appBarWidget = [
    const HomeAppBar(),
    const AddPostAppBar(),
    const ChatAppBar(),
    const NotificationAppBar(),
  ];

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
