import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/features/search/presentation/pages/people_tab_search_page.dart';
import 'package:sparkduet/features/search/presentation/pages/post_tab_search_page.dart';
import 'package:sparkduet/utils/custom_chip_widget.dart';

class TabSearchPage extends StatefulWidget {

  final String searchText;
  const TabSearchPage({super.key, required this.searchText});

  @override
  State<TabSearchPage> createState() => _TabSearchPageState();
}

class _TabSearchPageState extends State<TabSearchPage> with TickerProviderStateMixin {

  late PageController tabController;
  late List<Map<String, dynamic>> tabItems;
  ValueNotifier<int> activeTab = ValueNotifier(0);

  @override
  void initState() {
    tabItems = [
      {
        "key": "people",
        "page": PeopleTabSearchPage(searchText: widget.searchText,)
      },
      {
        "key": "posts",
        "page": PostTabSearchPage(searchText: widget.searchText,)
      },
    ];
    tabController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [

          SliverAppBar(
            elevation: 1,
            backgroundColor: theme.colorScheme.surface,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Row(
               children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FeatherIcons.search, size: 16,),
                        const SizedBox(width: 5,),
                        Text(widget.searchText, style: const TextStyle(fontSize: 14),)
                      ],
                    ),
                  ),
                  ),
                  const CloseButton()
               ],
            ),
            // actions: const [
            //   CloseButton()
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SizedBox(
                width: mediaQuery.size.width,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  child: ValueListenableBuilder<int>(valueListenable: activeTab, builder: (_, val, __) {
                    return SeparatedRow(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 0,);
                      },
                      children: [
                        CustomChipWidget(label: "People", active: val == 0, onTap: () {
                          activeTab.value = 0;
                          tabController.animateToPage(0, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                        },),
                        CustomChipWidget(label: "Posts", active: val == 1, onTap: () {
                          activeTab.value = 1;
                          tabController.animateToPage(1, duration: const Duration(milliseconds: 357), curve: Curves.linear);
                        },),
                      ],
                    );
                  }),
                ),
              ),
            ),
          )


        ];
      }, body: PageView.builder(
        controller: tabController,
        onPageChanged: (index) => activeTab.value = index,
        itemCount: tabItems.length,
        itemBuilder: (BuildContext context, int index) {
          final tabItem = tabItems[index];
          final page = tabItem['page'] as Widget;
          return page;
        },
      ),),
    );
  }
}
