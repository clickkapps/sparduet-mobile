import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sparkduet/features/countries/data/store/countries_cubit.dart';
import 'package:sparkduet/features/search/presentation/widgets/search_field_widget.dart';
import 'package:sparkduet/utils/custom_checkbox_widget.dart';

class CountriesPage extends StatefulWidget {

  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {

  late CountriesCubit countriesCubit;

  @override
  void initState() {
    countriesCubit = context.read<CountriesCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: const Text("Select countries", style: TextStyle(fontSize: 16),),
            backgroundColor: theme.colorScheme.surface,
            centerTitle: false,
            leading: const CloseButton(),
            pinned: true,
            elevation: 5,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: SearchFieldWidget(),
              ),
            ),
            actions: [
              TextButton(onPressed: () {}, child: Text("Done", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),))
            ],
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
              child: Text("Selected"),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Wrap(
                runSpacing: 8,
                spacing: 8,
                children: [
                  ...List.generate(3, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(4)
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                           children: [
                             Text("United States", style: TextStyle(fontSize: 12),),
                             SizedBox(width: 5,),
                             Icon(Icons.check_circle, size: 16, color: Colors.green,)
                           ],
                        ),
                      );
                  })
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
              child: Text("Countries"),
            ),
          )


        ];
      }, body: ListView.separated(itemBuilder: (ctx, i) {
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
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(FeatherIcons.search, size: 18,),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(child: Text("United States", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal, fontSize: 14),),),
                  const SizedBox(width: 10,),
                  CustomCheckboxWidget(onChange: (value) {
                    // above18.value = true;
                  }, borderRadius: 3, size: 25,
                    borderColor: theme.colorScheme.outline.withOpacity(0.5),
                    // fillColor: theme.brightness == Brightness.dark ? theme.colorScheme.outlineVariant : theme.colorScheme.background,
                    checked: false,),
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
