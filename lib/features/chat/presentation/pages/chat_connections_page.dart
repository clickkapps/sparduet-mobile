import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/features/home/data/nav_cubit.dart';
import 'package:sparkduet/utils/custom_badge_icon.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';
class ChatConnectionsPage extends StatelessWidget {
  const ChatConnectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

          return [
               SliverAppBar(
                elevation: 0,
                title: const Text("Inbox"),
                leading: CloseButton(color: theme.colorScheme.onBackground, onPressed: () => {
                  context.read<NavCubit>().requestTabChange(NavPosition.home)
                },),
              ),
               SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(itemBuilder: (_, i) {
                    return const UnconstrainedBox(child: CustomUserAvatarWidget(size: 70, online: true, showBorder: true,
                      imageUrl: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/04/21/12/woman-dating-app-photo.jpg?quality=75&width=1200&auto=webp",
                    ),);
                  }, separatorBuilder: (_, i) {
                    return const SizedBox(width: 10,);
                  }, itemCount: 5, scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 10, bottom: 10), ),
                ),
              ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Text("Recent chats"),
              ),
            )
          ];

        }, body:
          // Dont! use infinte scroll here. list all the previous chat of the user
      ListView.separated(itemBuilder: (ctx, i) {
          return  GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                   children: [
                     const CustomUserAvatarWidget(size: 55, showBorder: false, borderWidth: 1,),
                     const SizedBox(width: 10,),
                     Expanded(child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("John Doe", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),),
                          Text("Hello this is a message to be handled", style: theme.textTheme.bodySmall,),
                        ],
                     )),
                     const SizedBox(width: 10,),
                     Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(getFormattedDateWithIntl(DateTime.now(), format: "h:mm a"), style: theme.textTheme.bodySmall?.copyWith(),),
                            const SizedBox(height: 5,),
                            const CustomBadgeIcon(badgeCount: 2)
                          ],
                        )
                   ],
                ),
              ),
            ),
          );
      }, itemCount: 3, separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 1,);
      }, padding: const EdgeInsets.only(top: 0),),
      ),
    );
  }
}
