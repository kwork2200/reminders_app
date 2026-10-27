import 'package:flutter/material.dart';
import '../utils/functions.dart';

/// Intercepts back navigation (system back or Navigator.maybePop) on the
/// wrapped screen, shows an interstitial ad, then pops the route.
class AdOnBackWrapper extends StatefulWidget {
  final Widget child;

  const AdOnBackWrapper({super.key, required this.child});

  @override
  State<AdOnBackWrapper> createState() => _AdOnBackWrapperState();
}

class _AdOnBackWrapperState extends State<AdOnBackWrapper> {
  bool _isHandlingBack = false;

  Future<void> _handleBack() async {
    if (_isHandlingBack) return;
    _isHandlingBack = true;

    await showManagedInterstitialAd(context);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: widget.child,
    );
  }
}
