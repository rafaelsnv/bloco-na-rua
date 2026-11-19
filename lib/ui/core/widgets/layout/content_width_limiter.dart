import "package:bloco_na_rua/ui/core/tokens/app_spacing.dart";
import "package:flutter/widgets.dart";

/// Constrains [child] to [maxWidth] (defaulting to [Spacing.maxContentWidth])
/// and centers it horizontally on wider viewports.
///
/// Leaves vertical sizing unconstrained so scrollable children such as
/// [ListView] and [SingleChildScrollView] keep their normal scroll behavior.
class ContentWidthLimiter extends StatelessWidget {
  const ContentWidthLimiter({
    required this.child,
    this.maxWidth = Spacing.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
