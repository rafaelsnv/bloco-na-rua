import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

/// Base cubit that auto-reloads data when app resumes from background.
///
/// Extend this instead of Cubit to get auto-refresh on resume.
abstract class ResumableCubit<S> extends Cubit<S> with WidgetsBindingObserver {
  ResumableCubit(super.initialState) {
    WidgetsBinding.instance.addObserver(this);
  }

  final _log = Logger('ResumableCubit');
  bool _isReloading = false;

  Future<void> onResumed();

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && !_isReloading) {
      _isReloading = true;
      try {
        await onResumed();
      } catch (e, st) {
        _log.warning('onResumed failed', e, st);
      } finally {
        _isReloading = false;
      }
    }
  }

  @override
  @mustCallSuper
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
