import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sparkduet/network/network_provider.dart';

class SubscriptionRepository {

  final NetworkProvider networkProvider;
  final String? revenueCatProjectGoogleApiKey = dotenv.env['REVENUE_CAT_ANDROID_API_KEY'];
  final String? revenueCatProjectAppleApiKey = dotenv.env['REVENUE_CAT_IOS_API_KEY'];
  SubscriptionRepository({required this.networkProvider});


  Future<void> initSubscription(String appUserId) async {

    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(revenueCatProjectGoogleApiKey ?? "", )
        ..appUserID = appUserId;
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(revenueCatProjectAppleApiKey ?? "")
        ..appUserID = appUserId;
    }
    await Purchases.configure(configuration);


  }


  Future<Either<String, Offering?>> getOffering() async {

    try {

      // This syncs redemption codes with the app / play store
      // await Purchases.syncPurchases();

      final offerings = await Purchases.getOfferings();
      debugPrint("All offerings => $offerings");
      final offering = offerings.getOffering("sale-v3");
      return  Right(offering);

    }catch(e){
      return Left(e.toString());
    }
  }


  Future<Either<String, bool>> makePurchase(Package package) async {

    try {

      //todo removed Simulated subscription
      await Future.delayed(const Duration(seconds: 2));
      return const Right(true);

      final customerInfo = await Purchases.purchasePackage(package);
      if (customerInfo.entitlements.all["premium"]?.isActive ?? false) {
        return const Right(true);
      }
      return   const Right(false);

    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        // purchase was cancelled
        return const Left("Purchase cancelled");
      }
      if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        // purchase was cancelled
        return  const Right(true);
      }
      return const Left("Purchase cancelled");
    }
    catch(e){
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all["premium"]?.isActive ?? false) {
        return const Right(true);
      }
      return   const Right(false);
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      return Left(e.toString());
    }
  }

}