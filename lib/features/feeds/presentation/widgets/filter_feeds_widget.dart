import 'package:flutter/material.dart';
import 'package:sparkduet/utils/custom_button_widget.dart';
import 'package:sparkduet/utils/custom_card.dart';
import 'package:sparkduet/utils/custom_text_field_widget.dart';

class FilterFeedsWidget extends StatefulWidget {

  final ScrollController? scrollController;
  const FilterFeedsWidget({super.key, this.scrollController});

  @override
  State<FilterFeedsWidget> createState() => _FilterFeedsWidgetState();
}

class _FilterFeedsWidgetState extends State<FilterFeedsWidget> {

  // final String gender ;

  void onSubmitHandler(BuildContext ctx) {

  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return ColoredBox(
        color: theme.colorScheme.background,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Filter posts", style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),),
                const SizedBox(height: 30,),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Gender filter
                      // BlocBuilder<FiltersCubit, FiltersState>(
                      //   builder: (context, filterState) {
                      //     final gender = filterState.selectedGender;
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 15),
                      //           child: Text("Filter by preferred gender",
                      //             style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.w500),),
                      //         ),
                      //         const SizedBox(height: 0,),
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 5),
                      //           child: Row(
                      //             children: [
                      //               Expanded(child: RadioListTile<Gender>(
                      //                 title:  Text(Gender.male.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),),
                      //                 contentPadding: const EdgeInsets.only(left: 0, right: 0),
                      //                 visualDensity: const VisualDensity(horizontal: -4),
                      //                 value: Gender.male,
                      //                 activeColor: kAppRed,
                      //                 groupValue: gender,
                      //                 onChanged: (Gender? value) {
                      //                   state._genderChangedHandler(gender: Gender.male);
                      //                 },
                      //               )
                      //               ),
                      //               Expanded(flex: 1,child:
                      //               RadioListTile<Gender>(
                      //                 contentPadding:  EdgeInsets.zero,
                      //                 title: Text(Gender.female.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),),
                      //                 visualDensity: const VisualDensity(horizontal: -4),
                      //                 value: Gender.female,
                      //                 activeColor: kAppRed,
                      //                 groupValue: gender,
                      //                 onChanged: (Gender? value) {
                      //                   state._genderChangedHandler(gender: Gender.female);
                      //                 },
                      //               )
                      //               ),
                      //               Expanded(child:
                      //               RadioListTile<Gender>(
                      //                 title: Text(Gender.any.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface), textAlign: TextAlign.start,),
                      //                 // contentPadding: EdgeInsets.zero,
                      //                 //   contentPadding: const EdgeInsets.only( right: 0, left: 0),
                      //                 visualDensity: const VisualDensity(horizontal: -4),
                      //                 // dense: true,
                      //                 value: Gender.any,
                      //                 activeColor: kAppRed,
                      //                 groupValue: gender,
                      //                 onChanged: (Gender? value) {
                      //                   state._genderChangedHandler(gender: Gender.any);
                      //                 },
                      //               )
                      //                 //   Row(
                      //                 //   children: [
                      //                 //     Container(
                      //                 //       decoration: BoxDecoration(
                      //                 //           color: theme.colorScheme.outline,
                      //                 //           borderRadius: BorderRadius.circular(5)
                      //                 //       ),
                      //                 //       child: Radio<Gender>(
                      //                 //         value: Gender.any,
                      //                 //         activeColor: kAppRed,
                      //                 //         groupValue: gender,
                      //                 //         onChanged: (Gender? value) {
                      //                 //           state._gender.value = Gender.any;
                      //                 //         },
                      //                 //       ),
                      //                 //     ),
                      //                 //     const SizedBox(width: 10,),
                      //                 //     Text(Gender.any.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),)
                      //                 //   ],
                      //                 // )
                      //               ),
                      //             ],
                      //           ),
                      //         )
                      //         // Row(
                      //         //   children: [
                      //         //     Expanded(child: Row(
                      //         //       children: [
                      //         //         Container(
                      //         //           decoration: BoxDecoration(
                      //         //               color: theme.colorScheme.outline,
                      //         //               borderRadius: BorderRadius.circular(5)
                      //         //           ),
                      //         //           child: Radio<Gender>(
                      //         //             value: Gender.male,
                      //         //             activeColor: kAppRed,
                      //         //             groupValue: gender,
                      //         //             onChanged: (Gender? value) {
                      //         //               state._genderChangedHandler(gender: Gender.male);
                      //         //             },
                      //         //           ),
                      //         //         ),
                      //         //         const SizedBox(width: 5,),
                      //         //         Text(Gender.male.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),)
                      //         //       ],
                      //         //     )
                      //         //     ),
                      //         //     Expanded(flex: 2,child: Row(
                      //         //       mainAxisAlignment: MainAxisAlignment.center,
                      //         //       mainAxisSize: MainAxisSize.max,
                      //         //       children: [
                      //         //         Container(
                      //         //           decoration: BoxDecoration(
                      //         //               color: theme.colorScheme.outline,
                      //         //               borderRadius: BorderRadius.circular(5)
                      //         //           ),
                      //         //           child: Radio<Gender>(
                      //         //             value: Gender.female,
                      //         //             activeColor: kAppRed,
                      //         //             groupValue: gender,
                      //         //             onChanged: (Gender? value) {
                      //         //               state._genderChangedHandler(gender: Gender.female);
                      //         //             },
                      //         //           ),
                      //         //         ),
                      //         //         const SizedBox(width: 5,),
                      //         //         Text(Gender.female.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),)
                      //         //       ],
                      //         //     ),),
                      //         //     Expanded(child: Row(
                      //         //       children: [
                      //         //         Container(
                      //         //           decoration: BoxDecoration(
                      //         //               color: theme.colorScheme.outline,
                      //         //               borderRadius: BorderRadius.circular(5)
                      //         //           ),
                      //         //           child: Radio<Gender>(
                      //         //             value: Gender.any,
                      //         //             activeColor: kAppRed,
                      //         //             groupValue: gender,
                      //         //             onChanged: (Gender? value) {
                      //         //               state._genderChangedHandler(gender: Gender.any);
                      //         //             },
                      //         //           ),
                      //         //         ),
                      //         //         const SizedBox(width: 5,),
                      //         //         Text(Gender.any.name.capitalize(), style: TextStyle(color: theme.colorScheme.onSurface),)
                      //         //       ],
                      //         //     )),
                      //         //   ],
                      //         // ),
                      //       ],
                      //     );
                      //   },
                      // ),
                      /// End of Gender filter

                      CustomTextFieldWidget(
                        // controller: messageTextEditingController,
                        label: "Tell us why this video is inappropriate.",
                        // labelFontWeight: FontWeight.bold,
                        maxLines: null,
                        minLines: 4,
                        placeHolder: "eg. Contains nudes",
                      ),
                      const SizedBox(height: 10,),
                      CustomButtonWidget(text: "Apply filters", onPressed: () => onSubmitHandler(context), expand: true,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );

  }
}
