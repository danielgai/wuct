import 'package:flutter/material.dart';

class ScreenStackObserver extends NavigatorObserver {
  final List<String> screenStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    screenStack.add(route.settings.name ?? 'Unknown');
    _printStack();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    screenStack.removeLast();
    _printStack();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      screenStack.remove(oldRoute.settings.name ?? 'Unknown');
    }
    if (newRoute != null) {
      screenStack.add(newRoute.settings.name ?? 'Unknown');
    }
    _printStack();
  }

  void _printStack() {
    print('Current screen stack: $screenStack');
  }
}
