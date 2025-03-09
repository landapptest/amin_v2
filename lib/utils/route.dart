import 'package:flutter/material.dart';

/// AppRoutes 클래스는 앱 전체에서 사용되는 라우팅 메서드를 모아둡니다.
/// 각 메서드는 Navigator의 push, pushReplacement, pushAndRemoveUntil 등의 기능을 캡슐화합니다.
class AppRoutes {
  /// 기본 페이지 전환 (push)
  static Future<T?> push<T>(
      BuildContext context,
      Widget page, {
        RouteSettings? settings,
      }) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: settings,
      ),
    );
  }

  /// 페이지 전환 시 기존 화면을 대체 (pushReplacement)
  static Future<T?> pushReplacement<T, TO>(
      BuildContext context,
      Widget page, {
        RouteSettings? settings,
      }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: settings,
      ),
    );
  }

  /// 특정 조건에 맞게 기존 라우트 전체를 제거하고 새로운 페이지를 추가 (pushAndRemoveUntil)
  static Future<T?> pushAndRemoveUntil<T>(
      BuildContext context,
      Widget page, {
        required bool Function(Route<dynamic>) predicate,
        RouteSettings? settings,
      }) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: settings,
      ),
      predicate,
    );
  }

  //AppRoutes.pop
  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// 커스텀 전환 애니메이션을 적용하는 예시 메서드
  static Future<T?> pushWithTransition<T>(
      BuildContext context,
      Widget page, {
        Duration duration = const Duration(milliseconds: 300),
        RouteSettings? settings,
      }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        settings: settings,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 예: Fade Transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
