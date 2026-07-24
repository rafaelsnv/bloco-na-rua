import "package:equatable/equatable.dart";

/// Immutable state for the shared FAB expansion state.
class FabState extends Equatable {
  const FabState({this.expanded = false, this.shouldAnimate = true});

  final bool expanded;

  /// Whether collapse/expand animations should play.
  /// Set to false when dismissing due to navigation (instant collapse).
  final bool shouldAnimate;

  FabState copyWith({bool? expanded, bool? shouldAnimate}) => FabState(
        expanded: expanded ?? this.expanded,
        shouldAnimate: shouldAnimate ?? this.shouldAnimate,
      );

  @override
  List<Object?> get props => [expanded, shouldAnimate];
}
