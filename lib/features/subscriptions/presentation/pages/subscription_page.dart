import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_assets.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/subscriptions/data/store/enum.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_cubit.dart';
import 'package:sparkduet/features/subscriptions/data/store/subscription_state.dart';
import 'package:sparkduet/features/subscriptions/presentation/pages/sub_success_page.dart';
import 'package:sparkduet/utils/custom_border_widget.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';

class SubscriptionPage extends StatefulWidget {

  final ScrollController? scrollController;
  const SubscriptionPage({super.key, this.scrollController});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  
  ValueNotifier<Package?> selectedPackage = ValueNotifier(null);
  late SubscriptionCubit subscriptionCubit;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    subscriptionCubit = context.read<SubscriptionCubit>();
    streamSubscription = subscriptionCubit.stream.listen((event) {
      if(event.status == SubscriptionStatus.makePurchaseFailed) {
        context.showSnackBar("Oops! Subscription failed. Kindly try again later");
      }
      if(event.status == SubscriptionStatus.makePurchaseSuccessful) {
        showSuccessPage();
      }
    });
    initializePackages();
    super.initState();
  }
  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
  
  void initializePackages() async {
    final offering = await context.read<SubscriptionCubit>().getOffering();
    if(offering == null){
      debugPrint("Unable to fetch offering");
      return;
    }
    selectedPackage.value =  offering.availablePackages.first;
  }

  void showSuccessPage() {
    final ch = GestureDetector(
      // behavior: HitTestBehavior.opaque,
      // onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.9,
          shouldCloseOnMinExtent: true,
          builder: (_ , controller) {
            return  ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: SubSuccessPage(onTap: () {
                  context.popScreen();
                },)
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  //Column(
  //         mainAxisSize: MainAxisSize.min,
  //          children: [
  //            Lottie.asset(AppAssets.kEmptyChatJson ),
  //            Text(message ?? "Your messages will appear here", textAlign: TextAlign.center, style: theme.textTheme.titleSmall,)
  //          ],
  //       )

  void subscribeToPremiumHandler() {
    if(selectedPackage.value == null) {
      context.showSnackBar("Kindly select a package");
      return;
    }
    context.read<SubscriptionCubit>().makePurchase(selectedPackage.value!);
  }
  
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            actions:  const [
              UnconstrainedBox(
                child: CloseButton(color: AppColors.black,),
              ),
              SizedBox(width: 15)
            ],
            expandedHeight: mediaQuery.size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(AppAssets.premiumHeaderImage, fit: BoxFit.cover,),),

          )
        ];
      }, body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SeparatedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 15,);
            },
            children: [
              Text("Unlock all features 💕", style: theme.textTheme.titleLarge,),

              CustomCard(child: SeparatedColumn(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                separatorBuilder: (BuildContext context, int index) {
                  return const CustomBorderWidget(paddingTop: 10, paddingBottom: 10,);
                },
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green,),
                      const SizedBox(width: 10,),
                      Expanded(child: Text("Initiate conversations with everyone", style: theme.textTheme.bodySmall,))
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green,),
                      const SizedBox(width: 10,),
                      Expanded(child: Text("See who viewed your profile", style: theme.textTheme.bodySmall,))
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.green,),
                      const SizedBox(width: 10,),
                      Expanded(child: Text("See who viewed your posts", style: theme.textTheme.bodySmall,))
                    ],
                  ),
                ],
              )),
              
              BlocConsumer<SubscriptionCubit, SubscriptionState>(
                builder: (context, subState) {

                  return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       ///! Gender
                       CustomCard(
                         child:  Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Padding(
                               padding: const EdgeInsets.only(bottom: 10,),
                               child: Text("Packages",
                                 style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w700),),
                             ),
                             const SizedBox(height: 0,),
                             Container(
                               padding: const EdgeInsets.all(0),
                               width: double.maxFinite,
                               decoration: BoxDecoration(
                                 // border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                                   borderRadius: BorderRadius.circular(8)
                               ),
                               child: ValueListenableBuilder<Package?>(valueListenable: selectedPackage, builder: (_, selectedPkg, __) {
                                 return SeparatedColumn(
                                       separatorBuilder: (BuildContext context, int index) {
                                         return const CustomBorderWidget();
                                       },
                                       children: [

                                         ...(subState.offering?.availablePackages ?? []).map((package) {
                                           return GestureDetector(
                                             onTap: () {
                                               selectedPackage.value = package;
                                             },
                                             behavior: HitTestBehavior.opaque,
                                             child: Container(
                                               padding: const EdgeInsets.symmetric(vertical: 10),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   if(selectedPkg?.identifier == package.identifier) ... {
                                                     const Icon(Icons.check_circle, size: 20, color: Colors.green,)
                                                   }else ... {
                                                     Icon(Icons.check_circle, size: 20, color: theme.colorScheme.outline,)
                                                   },
                                                   const SizedBox(width: 10,),
                                                   Expanded(child: Row(
                                                      children: [
                                                        Text(package.packageType.name.capitalize()),
                                                        const SizedBox(width: 10,),
                                                        if(package.storeProduct.identifier.contains("1yr"))... {
                                                           Container(
                                                            decoration: BoxDecoration(
                                                                color: AppColors.buttonBlue.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(20)
                                                            ),
                                                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                             child: Text("Best value", style: theme.textTheme.bodySmall?.copyWith(color: AppColors.buttonBlue),),
                                                          )
                                                        }else ... {
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: AppColors.buttonBlue.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(20)
                                                            ),
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                            child: Text("Popular", style: theme.textTheme.bodySmall?.copyWith(color: AppColors.buttonBlue),),
                                                          )
                                                        }

                                                      ],
                                                   ),),
                                                   Text("${package.storeProduct.currencyCode} ${package.storeProduct.price.toStringAsFixed(2)} / ${package.storeProduct.subscriptionPeriod == "P1Y" ? "yr" : "mo"}" , style: theme.textTheme.bodySmall)
                                                 ],
                                               ),
                                             ),
                                           );
                                         })


                                       ],
                                     );


                               })


                             )

                           ],
                         ),
                       ),
                       const SizedBox(height: 15,),
                       if(!subState.subscribed) ... {
                         //Don't show this if payment is successful
                         CustomButtonWidget(text: "Unlock features", onPressed: subscribeToPremiumHandler, expand: true,
                           loading: subState.status == SubscriptionStatus.getOfferingInProgress || subState.status == SubscriptionStatus.makePurchaseInProgress,)
                       }
                     ],
                  );
                }, listener: (BuildContext context, SubscriptionState state) {
                  if(state.status == SubscriptionStatus.getOfferingFailed) {
                    context.popScreen();
                  }
                },
              )


            ],
          ),
      ),),
    );
  }
}
