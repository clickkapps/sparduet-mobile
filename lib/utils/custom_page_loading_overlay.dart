import 'package:flutter/material.dart';
import 'package:sparkduet/core/app_extensions.dart';
import 'package:sparkduet/core/app_functions.dart';
import 'package:sparkduet/utils/custom_animated_column_widget.dart';

/// loading indicator with some sort of animation
class CustomPageLoadingOverlay extends StatefulWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool loading;
  final Widget child;
  final String? message;
  final double opacity;
  final Color? assetColor;
  final int animationDuration;

  const CustomPageLoadingOverlay({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.loading = false,
    this.message,
    this.opacity = 0.5,
    this.assetColor,
    this.animationDuration = 300

  });

  @override
  State<CustomPageLoadingOverlay> createState() => _CustomPageLoadingOverlayState();
}

class _CustomPageLoadingOverlayState extends State<CustomPageLoadingOverlay>
    with TickerProviderStateMixin {
  var _overlayVisible = false;
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: widget.animationDuration));
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    onWidgetBindingComplete(onComplete: (){
      if(mounted) {
        _animation.addStatusListener((status) {
          status == AnimationStatus.forward
              ? setState(() => _overlayVisible = true)
              : null;
          status == AnimationStatus.dismissed
              ? setState(() => _overlayVisible = false)
              : null;
        });
        if (widget.loading) _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(CustomPageLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.loading && widget.loading) {
      _controller.forward();
    }

    if (oldWidget.loading && !widget.loading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(mounted) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        /// underlying UI
        Positioned.fill(child: widget.child),

        /// loading indicator semi-opaque background
        if (_overlayVisible) ...{
          FadeTransition(
            opacity: _animation,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Opacity(
                    opacity: widget.opacity,
                    child: ModalBarrier(
                      dismissible: false,
                      color: widget.backgroundColor ?? theme.colorScheme.primary,
                    ),
                  ),
                ),

                /// loading indicator
                Positioned.fill(child: Center(child: _indicator(theme),)),
              ],
            ),
          ),
        },
      ],
    );
  }

  Widget _indicator(ThemeData theme) => CustomAnimatedColumnWidget(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LoadingIndicator(),
          if (!widget.message.isNullOrEmpty()) ...{
            Text(widget.message!, style: TextStyle(color: theme.colorScheme.onBackground),)
          }
        ],
      );
}



class _LoadingIndicator extends StatelessWidget {

  const _LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    return SizedBox(width: 50, height: 50,
      child: Stack(
        children:  [
           SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: 2,
              color: theme.colorScheme.primary, //const Color(0xff8280F7),

            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Icon(Icons.favorite, color: theme.colorScheme.primary,)
          )
        ],
      ),
    );
  }
}

