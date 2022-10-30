import 'package:flutter/material.dart';
import 'package:dogslivery/Screen/Client/CartClientPage.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Client/ProfileClientPage.dart';
import 'package:dogslivery/Screen/Client/SearchClientPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class BottomNavigationDogsLivery extends StatelessWidget {
  final int index;

  BottomNavigationDogsLivery(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: -5)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ItemButton(
              i: 0,
              index: index,
              iconData: Icons.home_outlined,
              text: 'Inicio',
              onPressed: () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: ClientHomePage())),
            ),
            _ItemButton(
              i: 1,
              index: index,
              iconData: Icons.search,
              text: 'Pesquisar',
              onPressed: () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: SearchClientPage())),
            ),
            _ItemButton(
              i: 2,
              index: index,
              iconData: Icons.local_mall_outlined,
              text: 'Carrinho',
              onPressed: () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: CartClientPage())),
            ),
            _ItemButton(
              i: 3,
              index: index,
              iconData: Icons.person_outline_outlined,
              text: 'Perfil',
              onPressed: () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: ProfileClientPage())),
            ),
          ],
        ));
  }
}

class _ItemButton extends StatelessWidget {
  final int i;
  final int index;
  final IconData iconData;
  final String text;
  final VoidCallback? onPressed;

  const _ItemButton(
      {required this.i,
      required this.index,
      required this.iconData,
      required this.text,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
        decoration: BoxDecoration(
            color: (i == index)
                ? ColorsDogsLivery.primaryColor.withOpacity(.9)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15.0)),
        child: (i == index)
            ? Row(
                children: [
                  Icon(iconData, color: Colors.white, size: 25),
                  SizedBox(width: 6.0),
                  TextDogsLivery(
                      text: text,
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)
                ],
              )
            : Icon(iconData, size: 28),
      ),
    );
  }
}
