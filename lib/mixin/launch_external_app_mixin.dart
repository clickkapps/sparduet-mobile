import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';


/// In this mix all methods related to launch applications including browser, tel, email can be here
mixin LaunchExternalAppMixin {
  launchBrowser(String url) async{
    final launchUri = Uri.encodeFull(url);
    try{

      debugPrint("url: ${launchUri.toString()}");
      await canLaunchUrl(Uri.parse(launchUri)) ? await launchUrl(Uri.parse(launchUri)) : throw 'Could not launch $launchUri';
    }catch (error){
      debugPrint(error.toString());
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> openEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

}