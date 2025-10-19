import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/session_timeout_helper.dart';
import '../providers/user_provider.dart';

class SessionTimeoutWrapper extends StatefulWidget {
  final Widget child;

  const SessionTimeoutWrapper({super.key, required this.child});

  @override
  State<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends State<SessionTimeoutWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSessionTimer();
    });
  }

  void _startSessionTimer() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      SessionTimeoutHelper.startInactivityTimer(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user != null) {
          SessionTimeoutHelper.resetInactivityTimer(context);
        }
      },
      onPanUpdate: (_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user != null) {
          SessionTimeoutHelper.resetInactivityTimer(context);
        }
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    SessionTimeoutHelper.dispose();
    super.dispose();
  }
}
