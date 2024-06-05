import 'package:flutter/material.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:sparkduet/core/app_colors.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/mixin/launch_external_app_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

///iMessage's chat bubble type
///
///chat bubble color can be customized using [color]
///chat bubble tail can be customized  using [tail]
///chat bubble display message can be changed using [text]
///[text] is the only required parameter
///message sender can be changed using [isSender]
///chat bubble [TextStyle] can be customized using [textStyle]

class ChatBubbleWidget extends StatelessWidget with LaunchExternalAppMixin {
  final bool isSender;
  final String text;
  final bool tail;
  final Color color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final BoxConstraints? constraints;
  final DateTime? timeStamp;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ChatBubbleWidget({
    super.key,
    this.isSender = true,
    this.constraints,
    required this.text,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.timeStamp,
    this.onLongPress,
    this.onTap,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  });

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final timeWidget = Text(getFormattedDateWithIntl(timeStamp ?? DateTime.now(), format: "hh:mm a"), style: theme.textTheme.titleSmall?.copyWith(color: isSender ? Colors.white70 : theme.textTheme.titleSmall?.color, fontSize: 11),);
    // final timeWidget = Text(getFormattedDateWithIntl(timeStamp ?? DateTime.now(), format: "hh:mm a"), style: theme.textTheme.titleSmall?.copyWith(color: theme.textTheme.titleSmall?.color, fontSize: 11),);

    bool stateTick = false;
    Widget? stateIcon;
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 12,
        color: Colors.white70,
      );
    }
    // if (delivered) {
    //   stateTick = true;
    //   stateIcon = const Icon(
    //     Icons.done_all,
    //     size: 14,
    //     color: Colors.white70,
    //   );
    // }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 12,
        color: Colors.white70,
      );
    }

    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            CustomPaint(
              painter: SpecialChatBubbleThree(
                  color: color,
                  alignment: isSender ? Alignment.topRight : Alignment.topLeft,
                  tail: tail),
              child: Container(
                constraints: constraints ??
                    BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .7,
                    ),
                margin: isSender
                    ? stateTick
                    ? const EdgeInsets.fromLTRB(7, 7, 14, 7)
                    : const EdgeInsets.fromLTRB(7, 7, 17, 7)
                    : const EdgeInsets.fromLTRB(17, 7, 7, 7),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      // padding: (stateTick && isSender)
                      //     ? const EdgeInsets.only(left: 4, right: 015)
                      //     : ,
                      child: Column(
                         crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           // Padding(padding: (stateTick && isSender) ? const EdgeInsets.only(left: 0, right: 10): EdgeInsets.zero,
                           //   child: SelectableAutoLinkText(
                           //                              text,
                           //                              style: textStyle,
                           //                              linkStyle: textStyle.copyWith(color: kLuckyPointBlue),
                           //                              highlightedLinkStyle: textStyle.copyWith(
                           //                                color: Colors.purpleAccent,
                           //                              ),
                           //                              linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.defaultLinkRegExpPattern})',
                           //                              // onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                           //                              // enableInteractiveSelection: false,
                           //                              onTap: (url) async {
                           //
                           //                                if (isContainingAnyLink(text)) {
                           //                                  await launchBrowser(url);
                           //                                  return;
                           //                                }
                           //
                           //                                if (isPhoneNumber(text)) {
                           //                                  makePhoneCall(text);
                           //                                  return;
                           //                                }
                           //
                           //                                if (isEmail(text)) {
                           //                                  openEmail(text);
                           //                                  return;
                           //                                }
                           //
                           //                                if (await canLaunchUrl(Uri.parse(url))) {
                           //                                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                           //                                }
                           //
                           //                              },
                           //                              onLongPress: (url) {
                           //                                copyTextToClipBoard(context, url);
                           //                              },
                           //                              onTapOther: (a,b) {
                           //                                onTap?.call();
                           //                              },
                           //                              onLongPressOther: (a, b) {
                           //                                onLongPress?.call();
                           //                              },
                           //                            ),
                           // ),
                           SelectableAutoLinkText(
                             text,
                             style: textStyle,
                             linkStyle: textStyle.copyWith(color: isSender ? AppColors.white : AppColors.buttonBlue),
                             highlightedLinkStyle: textStyle.copyWith(
                               color: Colors.purpleAccent,
                             ),
                             linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.defaultLinkRegExpPattern})',
                             // onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
                             // enableInteractiveSelection: false,
                             onTap: (url) async {

                               if (isContainingAnyLink(text)) {
                                 await launchBrowser(url);
                                 return;
                               }

                               if (isPhoneNumber(text)) {
                                 makePhoneCall(text);
                                 return;
                               }

                               if (isEmail(text)) {
                                 openEmail(text);
                                 return;
                               }

                               if (await canLaunchUrl(Uri.parse(url))) {
                                 await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                               }

                             },
                             onLongPress: (url) {
                               copyTextToClipBoard(context, url);
                             },
                             onTapOther: (a,b) {
                               onTap?.call();
                             },
                             onLongPressOther: (a, b) {
                               onLongPress?.call();
                             },
                           ),

                           Padding(
                             padding: isSender ? const EdgeInsets.only(left: 0, right: 12) : const EdgeInsets.only(left: 0),
                             child: timeWidget,
                           )

                         ],
                      ),
                    ),
                    if (stateIcon != null && stateTick && isSender) ... {
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: stateIcon,
                      )
                    },

                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: isSender ? const EdgeInsets.only(left: 0, right: 15) : const EdgeInsets.only(left: 12),
            //   child: timeWidget,
            // )

          ],
        ),
      ),
    );
  }
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleThree extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleThree({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);
        // bottom-right tail curve 1
        path.quadraticBezierTo(_radius * .8, h, 0, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            _radius * 1, h, _radius * 1.5, h - _radius * 0.6);

        /// bottom-left bubble curve
        path.quadraticBezierTo(_radius * 1.5, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        var path = Path();

        /// starting point
        path.moveTo(_radius * 3, 0);

        /// top-left corner
        path.quadraticBezierTo(_radius, 0, _radius, _radius * 1.5);

        /// left line
        path.lineTo(_radius, h - _radius * 1.5);

        /// bottom-left curve
        path.quadraticBezierTo(_radius, h, _radius * 3, h);

        /// bottom line
        path.lineTo(w - _radius * 2, h);

        /// bottom-right curve
        path.quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path.lineTo(w, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
