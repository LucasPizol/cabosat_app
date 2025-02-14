import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget? child;
  final Gradient? gradient;
  final double? width;
  final double height;
  final GestureTapCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  const RaisedGradientButton({
    super.key,
    @required this.child,
    this.gradient,
    this.width,
    this.height = 50.0,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  Widget getButton() {
    return Opacity(
      opacity: isLoading ? 0.5 : 1,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
              onTap: isLoading ? null : onPressed,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : icon != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                icon!,
                                const SizedBox(width: 10),
                                child!,
                              ],
                            )
                          : child,
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (width != null) {
      return getButton();
    }

    return Row(
      children: [getButton()],
    );
  }
}
