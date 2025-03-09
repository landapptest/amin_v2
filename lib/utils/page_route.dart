import 'package:flutter/material.dart';

Route createDownToUpSlideRoute(nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return nextPage;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);  // 화면의 시작 위치
      const end = Offset.zero;         // 화면의 끝 위치 (기본 위치)
      const curve = Curves.easeInOut;  // 애니메이션의 곡선

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route createleftToRightSlideRoute(nextPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return nextPage;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  EnterExitRoute({required this.exitPage, required this.enterPage})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: const Offset(-1.0, 0.0),
              ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
              child: exitPage,
            ),
            SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
              child: enterPage,
            )
          ],
        ),
  );
}

class CreateUpToDownSlideRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  CreateUpToDownSlideRoute({required this.exitPage, required this.enterPage})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        Stack(
          children: <Widget>[
            // enterPage는 고정
            enterPage,
            // exitPage만 애니메이션을 적용하여 아래로 슬라이드
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0), // 현재 위치
                end: const Offset(0.0, 1.0), // 아래로 슬라이드
              ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
              child: exitPage,
            ),
          ],
        ),
  );
}