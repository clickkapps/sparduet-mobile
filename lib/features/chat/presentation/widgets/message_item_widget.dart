import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/features/auth/data/store/auth_cubit.dart';
import 'package:sparkduet/features/chat/data/models/chat_message_model.dart';
import 'package:sparkduet/features/chat/presentation/widgets/chat_bubble_widget.dart';

class MessageItemWidget extends StatelessWidget {

  final ChatMessageModel message;
  final Function(ChatMessageModel)? onLongPress;
  const MessageItemWidget({super.key, required this.message, this.onLongPress});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final hasParentMessage = message.parent != null;
    final  authUser = context.read<AuthCubit>().state.authUser;
    final isSender = message.sentById == authUser?.id;

    void onLongPressHandler() {
      HapticFeedback.lightImpact();
      // openMessageOptionsModal(context);
      onLongPress?.call(message);
    }

    return GestureDetector(
      onLongPress: onLongPressHandler,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(top: hasParentMessage ? 40 : 0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            //! Parent message if any ....
            if(hasParentMessage) ... {

              Positioned(
                top: -35,
                right: isSender ? 0 : null,
                left: !isSender ? 0 : null,
                // left: message.parentMessage == null ? null :  (!(message.isSender ?? false)  ? 0 : null),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(theme.brightness == Brightness.dark ? 0.85 : 0.5)),
                      borderRadius: BorderRadius.circular(5),
                  ),
                  constraints: BoxConstraints(maxWidth: media.size.width * 0.65),
                  margin: EdgeInsets.only(bottom: 0, left: !isSender ? 18 : 0 , right: isSender ? 18 : 0, top: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30, top: 10, left: 10, right: 10),
                    child: Text(message.parent?.text ?? "",
                      style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  ),
                ),),

            },

            // Main message ...
            ChatBubbleWidget(
              text: message.text ?? "",
              color: isSender ? const Color(0xff3498DB) : const Color(0xffD9DADB),
              tail: isSender ? false : true,
              textStyle: TextStyle(color: isSender  ? AppColors.white : AppColors.black),
              isSender: isSender,
              seen: message.seenAt != null,
              delivered: message.deliveredAt != null,
              timeStamp: message.createdAt,
              onLongPress: onLongPressHandler,
            )
          ],
        ),
      ),
    );
  }
}


//if (model.message != null && model.message != "") ... {
//                                               SelectableAutoLinkText(
//                                                 model.message!,
//                                                 style: TextStyle(
//                                                     color: theme.colorScheme.onBackground,
//                                                     fontSize: defaultFontSize,
//                                                     fontWeight: FontWeight.w500),
//                                                 linkStyle: const TextStyle(color: kLuckyPointBlue),
//                                                 highlightedLinkStyle: const TextStyle(
//                                                   color: Colors.purpleAccent,
//                                                 ),
//                                                 linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.defaultLinkRegExpPattern})',
//                                                 // onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
//                                                 // enableInteractiveSelection: false,
//                                                 onTap: (url) async {
//                                                   if (url.startsWith('@')) {
//                                                     // Navigator.push(
//                                                     //   context,
//                                                     //   MaterialPageRoute(
//                                                     //     builder: (context) => ProfilePage(
//                                                     //       username: url.substring(1),
//                                                     //     ),
//                                                     //   ),
//                                                     // );
//                                                     return;
//                                                   }
//
//                                                   if (isContainingAnyLink(model.message)) {
//                                                     await launchBrowser(url);
//                                                     return;
//                                                   }
//
//                                                   if (isPhoneNumber(model.message)) {
//                                                     makePhoneCall(model.message!);
//                                                     return;
//                                                   }
//
//                                                   if (isEmail(model.message)) {
//                                                     openEmail(model.message!);
//                                                     return;
//                                                   }
//
//                                                   if (await canLaunchUrl(Uri.parse(url))) {
//                                                     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//                                                   }
//
//                                                 },
//                                                 onLongPress: (url) {
//                                                   copyTextToClipBoard(context, url);
//                                                 },
//                                                 onTapOther: (a,b) {
//                                                 },
//                                                 onLongPressOther: (a, b) {},
//                                               ),
//                                               if(isContainingAnyLink(model.message)) CustomAnyLinkPreviewWidget(message:model.message!,topPadding: 0,)
//                                             },
