import 'package:feather_icons/feather_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/feeds/data/models/feed_model.dart';
import 'package:sparkduet/features/search/presentation/pages/tab_search_page.dart';
import 'package:sparkduet/features/search/presentation/widgets/search_field_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/completed_user_post_item.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class TopSearchPage extends StatefulWidget {
  const TopSearchPage({super.key});

  @override
  State<TopSearchPage> createState() => _TopSearchPageState();
}

class _TopSearchPageState extends State<TopSearchPage> {
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

        return  [
          SliverAppBar(
            backgroundColor: theme.colorScheme.surface,
            title: const Text(""),
            centerTitle: false,
            leading: const CloseButton(),
            pinned: true,
            elevation: 1,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 0, bottom: 10),
                child: Row(
                   children: [
                      const Expanded(child: SearchFieldWidget()),
                      const SizedBox(width: 0,),
                      TextButton(onPressed: (){
                        context.pushScreen(const TabSearchPage(searchText: "Love at its peak"));
                      }, child: const Text("Search"))
                   ],
                ),
              ),
            ),
          )
        ];

      }, body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 20,);
        },
          children: [

            ///! Recent Searches
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text("Recent"),
                ),
                SeparatedColumn(separatorBuilder: (_,__) {
                  return const SizedBox(height: 1,);
                }, children: List.generate(3, (index) {
                  return GestureDetector(
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
                            // just icon
                            Container(
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.outlineVariant,
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(FeatherIcons.search, size: 18,),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(child: Text("Love at its peak", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),),
                            const SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),
                  );
                }),)
              ],
            ),

            ///! Top People Search
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text("People"),
                ),
                SeparatedColumn(separatorBuilder: (_,__) {
                  return const SizedBox(height: 1,);
                }, children: List.generate(3, (index) {
                  return GestureDetector(
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
                          ],
                        ),
                      ),
                    ),
                  );
                }),)
              ],
            ),

            ///! Top Stories Search
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Text("Posts"),
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: mediaQuery.size.width / 3,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      childAspectRatio: 100 / 150,
                    ),
                    itemBuilder: (BuildContext ctx, int index) {

                      const post = FeedModel(id: 1, mediaType: FileType.video, mediaPath: "PB7GFdH00Fm7nWT41xU8XU02R92v9rDqWkM5snMV01coHw");
                      return CompletedUserPostItem(post: post, onTap: () {
                        // context.pushScreen(StoriesPreviewsPage(feeds: feedsCubit.state.feeds, initialFeedIndex: feedsCubit.state.feeds.indexWhere((element) => element.id == post.id),));
                      },);
                    },
                    itemCount: 6,
                  ),
                )



              ],
            )

          ],

        ),
      ),
      ),
    );
  }
}
