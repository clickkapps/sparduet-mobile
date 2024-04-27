import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkduet/app/routing/app_routes.dart';
import 'package:sparkduet/core/app_functions.dart';
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
              const SliverAppBar(
                elevation: 0,
                title: Text("Inbox"),
              ),
               SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                  child: ListView.separated(itemBuilder: (_, i) {
                    return const UnconstrainedBox(child: CustomUserAvatarWidget(size: 90, online: true, showBorder: true,
                      imageUrl: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/04/21/12/woman-dating-app-photo.jpg?quality=75&width=1200&auto=webp",
                    ),);
                  }, separatorBuilder: (_, i) {
                    return const SizedBox(width: 10,);
                  }, itemCount: 5, scrollDirection: Axis.horizontal, padding: const EdgeInsets.only(left: 10, bottom: 10), ),
                ),
              )
          ];

        }, body:
          // Dont! use infinte scroll here. list all the previous chat of the user
      ListView.separated(itemBuilder: (ctx, i) {
          return  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              leading:  const CustomUserAvatarWidget(size: 55, showBorder: false, borderWidth: 1,),
              title:  Text("John Doe", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text("Hello this is a message to be handled", style: theme.textTheme.bodySmall,),
              trailing: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Text(getFormattedDateWithIntl(DateTime.now(), format: "h:mm a"), style: theme.textTheme.bodySmall?.copyWith(),),
                   const SizedBox(height: 5,),
                   const CustomBadgeIcon(badgeCount: 2)
                 ],
              ),
              onTap: () {
                context.push("${AppRoutes.inbox}/1234");
              },
              dense: true,
              visualDensity: const VisualDensity(horizontal: -4),
              contentPadding: EdgeInsets.zero,
            ),
          );
      }, itemCount: 3, separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10,);
      }, padding: const EdgeInsets.only(top: 0),),
      ),
    );
  }
}
