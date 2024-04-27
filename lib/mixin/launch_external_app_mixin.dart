import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';


/// In this mix all methods related to launch applications including browser, tel, email can be here
mixin LaunchExternalAppMixin {
  launchBrowser(String url, BuildContext context) async{
    final launchUri = Uri.encodeFull(url);
    try{

      debugPrint("url: ${launchUri.toString()}");
      await canLaunchUrl(Uri.parse(launchUri)) ? await launchUrl(Uri.parse(launchUri)) : throw 'Could not launch $launchUri';
    }catch (error){
      debugPrint(error.toString());
    }

  }
}