import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/presentation/widgets/filter_feeds_widget.dart';
import 'package:sparkduet/utils/custom_heart_animation_widget.dart';

class FeedActionsWidget extends StatefulWidget {


  const FeedActionsWidget({super.key});

  @override
  State<FeedActionsWidget> createState() => _FeedActionsWidgetState();
}

class _FeedActionsWidgetState extends State<FeedActionsWidget> {

  final ValueNotifier<bool> liked = ValueNotifier(false);
  final ValueNotifier<bool> bookmarked = ValueNotifier(false);

  void filterPostsHandler(BuildContext context) {
    final ch = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.7,
          minChildSize: 0.6,
          builder: (_ , controller) {
            return const ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: FilterFeedsWidget()
            );
          }
      ),
    );
    context.showCustomBottomSheet(child: ch, borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), backgroundColor: Colors.transparent, enableBottomPadding: false);
  }

  void reportPostHandler(BuildContext context) {

  }

  void commentsHandler(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {

    return SeparatedColumn(
      mainAxisSize: MainAxisSize.min,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20,);
      },
      children: [



        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                filterPostsHandler(context);
              },
              child: const CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(FeatherIcons.sliders, size: 25, color: Colors.white,)
              ),
            ),
            const SizedBox(width: 5,),
            const Text("Filter posts", style: TextStyle(color: Colors.white, fontSize:11),),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.showSnackBar("coming soon");
              },
              child: const CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(Icons.bookmark, size: 30, color: Colors.white,)
              ),
            ),
            const SizedBox(width: 5,),
            const Text("Bookmark", style: TextStyle(color: Colors.white, fontSize:11),),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.showSnackBar("coming soon");
              },
              child: const CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(Icons.health_and_safety, size: 30, color: Colors.white,)
              ),
            ),
            const SizedBox(width: 5,),
            const Text("Inappropriate", style: TextStyle(color: Colors.white, fontSize:11),),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.showSnackBar("coming soon");
              },
              child: const CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(Icons.message, size: 27, color: Colors.white,)
              ),
            ),
            const SizedBox(width: 5,),
            const Text("2.5k", style: TextStyle(color: Colors.white, fontSize:11),),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.showSnackBar("coming soon");
              },
              child: const CustomHeartAnimationWidget(
                  isAnimating: false,
                  alwayAnimate: true,
                  child: Icon(FontAwesomeIcons.solidComments, size: 27, color: AppColors.buttonBlue,)
              ),
            ),
            const SizedBox(width: 5,),
            const Text("Chat", style: TextStyle(color: AppColors.buttonBlue, fontSize:11),),
          ],
        ),

        /// Like
        ValueListenableBuilder(valueListenable: liked, builder: (_, val, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  liked.value = !liked.value;
                },
                child: CustomHeartAnimationWidget(
                    isAnimating: val,
                    alwayAnimate: true,
                    child: val ? const Icon(Icons.favorite, size: 32, color: Colors.red,) : const Icon(Icons.favorite, size: 32, color: Colors.white,)
                ),
              ),
              const SizedBox(width: 5,),
              Text(val ? "201" : "200", style: TextStyle(color: val ? Colors.red : Colors.white, fontSize: 12),),
            ],
          );
        }),


      ],
    );
  }
}
