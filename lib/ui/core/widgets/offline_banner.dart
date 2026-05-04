import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Controller for OfflineBanner state management.
///
/// Use with ChangeNotifierProvider to expose offline state globally.
class OfflineBannerController extends ChangeNotifier {
  OfflineBannerController({bool initialOffline = false}) : _isOffline = initialOffline;

  bool _isOffline;
  bool get isOffline => _isOffline;

  /// Updates the offline state and notifies listeners.
  void setOffline(bool value) {
    if (_isOffline != value) {
      _isOffline = value;
      notifyListeners();
    }
  }
}

/// Banner widget that displays an offline warning at the top of the screen.
///
/// Appears with slide-down + fade-in animation when network is unavailable.
/// Positioned fixed below the AppBar with 48dp height.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({
    super.key,
    this.message,
    this.onRetry,
  });

  /// Custom message to display (optional).
  /// Defaults to "Sem conexão com a internet".
  final String? message;

  /// Callback when user taps "Tentar novamente".
  final VoidCallback? onRetry;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _show() {
    if (!_isVisible) {
      _isVisible = true;
      _controller.forward();
    }
  }

  void _hide() {
    if (_isVisible) {
      _isVisible = false;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfflineBannerController>(
      builder: (context, controller, _) {
        final isOffline = controller.isOffline;

        // Trigger animation based on state change
        if (isOffline && !_isVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _show());
        } else if (!isOffline && _isVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _hide());
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_controller.isDismissed) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 48,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    color: Colors.orange.shade800,
                    child: SafeArea(
                      bottom: false,
                      child: SizedBox(
                        height: 48,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.message ??
                                      'Sem conexão com a internet',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.onRetry != null)
                                TextButton(
                                  onPressed: widget.onRetry,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Tentar novamente',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
