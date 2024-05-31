import 'package:easy_debounce/easy_debounce.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_constants.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/feeds/presentation/pages/stories_previews_page.dart';
import 'package:sparkduet/features/search/data/store/enums.dart';
import 'package:sparkduet/features/search/data/store/search_cubit.dart';
import 'package:sparkduet/features/search/data/store/search_state.dart';
import 'package:sparkduet/features/search/presentation/pages/tab_search_page.dart';
import 'package:sparkduet/features/search/presentation/widgets/search_field_widget.dart';
import 'package:sparkduet/features/users/presentation/widgets/completed_user_post_item.dart';
import 'package:sparkduet/features/users/presentation/widgets/user_list_item_widget.dart';
import 'package:sparkduet/utils/custom_user_avatar_widget.dart';

class TopSearchPage extends StatefulWidget {

  const TopSearchPage({super.key});

  @override
  State<TopSearchPage> createState() => _TopSearchPageState();
}

class _TopSearchPageState extends State<TopSearchPage> {

  bool showFrequentSearchTerms = true;
  final searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late SearchCubit searchCubit;

  @override
  void initState() {
    searchCubit = context.read<SearchCubit>();
    searchCubit.fetchPopularSearchTerms();
    searchCubit.fetchRecentSearchTerms();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void onSearchTextChanged(String? value) {
    EasyDebounce.debounce('top-country', const Duration(milliseconds: 1000), () {
      if(value == '' || value == null){
        searchCubit.fetchPopularSearchTerms();
        searchCubit.fetchRecentSearchTerms();
        setState(() {showFrequentSearchTerms = true;});
      }else {
        setState(() {showFrequentSearchTerms = false;});
        searchCubit.topSearch(query: value, authUserId: context.read<AuthCubit>().state.authUser?.id);
      }
    });
  }

  void onFullSearchTapped(BuildContext context, String searchText) async {
    searchFocusNode.unfocus();
    final searchTerm = await context.pushScreen(TabSearchPage(searchText: searchText)) as String?;
    if((searchTerm ?? "").isNotEmpty) {
      searchTextController.text = searchText;
      searchFocusNode.requestFocus();
    }
  }

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 0, bottom: 10),
                    child: Row(
                       children: [
                          Expanded(child: SearchFieldWidget(
                            focusNode: searchFocusNode,
                            onChanged: onSearchTextChanged,
                            onSubmitted: (value) {
                              if(searchTextController.text.trim().isEmpty) {
                                return;
                              }
                              onFullSearchTapped(context, searchTextController.text.trim());
                            },
                            controller: searchTextController,)),
                          if(showFrequentSearchTerms) ... {
                            const SizedBox(width: 15,),
                          },
                          if(!showFrequentSearchTerms) ... {
                            TextButton(onPressed: (){
                              if(searchTextController.text.trim().isEmpty) {
                                return;
                              }
                              onFullSearchTapped(context, searchTextController.text.trim());
                            }, child: const Text("Search"))
                          }
                       ],
                    ),
                  ),
                  BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if(state.status == SearchStatus.topSearchInProgress) {
                        return LinearProgressIndicator(minHeight: 2, color: theme.colorScheme.primary,);
                      }
                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          )
        ];

      }, body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SeparatedColumn(separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0,);
        },
          children: [

            ///! Recent Searches
            if(showFrequentSearchTerms) ... {
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (_, state) {
                  return state.status == SearchStatus.recentSearchTermsSuccessful;
                },
                builder: (context, state) {
                  if(state.recentSearch.isEmpty){
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Text("Recent"),
                        ),
                        SeparatedColumn(separatorBuilder: (_,__) {
                          return const SizedBox(height: 1,);
                        }, children: List.generate(state.recentSearch.take(5).length, (index) {
                          return GestureDetector(
                            onTap: () {
                              onFullSearchTapped(context, state.recentSearch[index]);
                            },
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
                                      child: const Icon(FeatherIcons.search, size: 14,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(child: Text(state.recentSearch[index], style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis,),),
                                    const SizedBox(width: 10,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),)
                      ],
                    ),
                  );
                },
              )
            },

            ///! Popular searches
            if(showFrequentSearchTerms) ... {
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (_, state) {
                  return state.status == SearchStatus.popularSearchTermsSuccessful;
                },
                builder: (context, state) {
                  if(state.popularSearch.isEmpty){
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Text("Popular search"),
                        ),
                        SeparatedColumn(separatorBuilder: (_,__) {
                          return const SizedBox(height: 1,);
                        }, children: List.generate(state.popularSearch.take(5).length, (index) {
                          return GestureDetector(
                            onTap: () {
                              onFullSearchTapped(context, state.popularSearch[index]);
                            },
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
                                      child: const Icon(FeatherIcons.search, size: 14,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Expanded(child: Text(state.popularSearch[index], style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,),),
                                    const SizedBox(width: 10,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),)
                      ],
                    ),
                  );
                },
              )
            },

            ///! Top People Search
            if(!showFrequentSearchTerms) ... {
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (_, state) {
                  return state.status == SearchStatus.topSearchSuccessful;
                },
                builder: (context, state) {
                  if(state.topSearch.$1.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Text("People"),
                        ),
                        SeparatedColumn(separatorBuilder: (_,__) {
                          return const SizedBox(height: 1,);
                        }, children: List.generate(state.topSearch.$1.length, (index) {
                          final user = state.topSearch.$1[index];
                          return UserListItemWidget(user: user);
                        }),)
                      ],
                    ),
                  );
                },
              )
            },

            ///! Top Stories Search
            if(!showFrequentSearchTerms) ... {
              BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (_, state) {
                  return state.status == SearchStatus.topSearchSuccessful;
                },
                builder: (context, state) {
                  if(state.topSearch.$2.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
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

                              final post = state.topSearch.$2[index];
                              return CompletedUserPostItem(post: post, onTap: () {
                                context.pushScreen(StoriesPreviewsPage(feeds: state.topSearch.$2, initialFeedIndex: index,));
                              },);
                            },
                            itemCount: state.topSearch.$2.length,
                          ),
                        )



                      ],
                    ),
                  );
                },
              )
            }

          ],

        ),
      ),
      ),
    );
  }
}
