// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Bloc/Cart/cart_bloc.dart';
import 'package:dogslivery/Screen/Client/CheckOutPage.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class CartClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextDogsLivery(
            text: 'Meu Carrinho', fontSize: 20, fontWeight: FontWeight.w500),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: ColorsDogsLivery.primaryColor, size: 19),
              TextDogsLivery(
                  text: 'Voltar',
                  fontSize: 16,
                  color: ColorsDogsLivery.primaryColor)
            ],
          ),
          onPressed: () => Navigator.pushAndRemoveUntil(context,
              routeDogsLivery(page: ClientHomePage()), (route) => false),
        ),
        actions: [
          Center(
              child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) => TextDogsLivery(
                      text: '${state.quantityCart} Itens', fontSize: 17))),
          SizedBox(width: 10.0)
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) => (state.quantityCart != 0)
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: state.quantityCart,
                          itemBuilder: (_, i) => Dismissible(
                                key: Key(state.products![i].uidProduct),
                                direction: DismissDirection.endToStart,
                                background: Container(),
                                secondaryBackground: Container(
                                  padding: EdgeInsets.only(right: 35.0),
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  alignment: Alignment.centerRight,
                                  // ignore: prefer_const_constructors
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      // ignore: prefer_const_constructors
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.0),
                                          bottomRight: Radius.circular(20.0))),
                                  child: Icon(Icons.delete_sweep_rounded,
                                      color: Colors.white, size: 40),
                                ),
                                onDismissed: (direccion) =>
                                    cartBloc.add(OnDeleteProductToCartEvent(i)),
                                child: Container(
                                    height: 90,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 15.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  scale: 8,
                                                  image: NetworkImage(
                                                      URLS.BASE_URL +
                                                          state.products![i]
                                                              .imageProduct))),
                                        ),
                                        Container(
                                          width: 130,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextDogsLivery(
                                                  text: state
                                                      .products![i].nameProduct,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20),
                                              SizedBox(height: 10.0),
                                              TextDogsLivery(
                                                  text:
                                                      '\$ ${state.products![i].price * state.products![i].quantity}',
                                                  color: ColorsDogsLivery
                                                      .primaryColor)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    decoration: BoxDecoration(
                                                        color: ColorsDogsLivery
                                                            .primaryColor,
                                                        shape: BoxShape.circle),
                                                    child: InkWell(
                                                      child: Icon(Icons.remove,
                                                          color: Colors.white),
                                                      onTap: () {
                                                        if (state.products![i]
                                                                .quantity >
                                                            1)
                                                          cartBloc.add(
                                                              OnDecreaseProductQuantityToCartEvent(
                                                                  i));
                                                      },
                                                    )),
                                                SizedBox(width: 10.0),
                                                TextDogsLivery(
                                                    text:
                                                        '${state.products![i].quantity}',
                                                    color: ColorsDogsLivery
                                                        .primaryColor),
                                                SizedBox(width: 10.0),
                                                Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    decoration: BoxDecoration(
                                                        color: ColorsDogsLivery
                                                            .primaryColor,
                                                        shape: BoxShape.circle),
                                                    child: InkWell(
                                                        child: Icon(Icons.add,
                                                            color:
                                                                Colors.white),
                                                        onTap: () => cartBloc.add(
                                                            OnIncreaseQuantityProductToCartEvent(
                                                                i))))
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ))
                      : _WithOutProducts()),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10.0)),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextDogsLivery(text: 'Total'),
                          TextDogsLivery(text: '${state.total}'),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextDogsLivery(text: 'Sub Total'),
                          TextDogsLivery(text: '${state.total}'),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      BtnDogsLivery(
                        text: 'Checkout',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: (state.quantityCart != 0)
                            ? ColorsDogsLivery.primaryColor
                            : ColorsDogsLivery.secundaryColor,
                        onPressed: () {
                          if (state.quantityCart != 0) {
                            Navigator.push(
                                context, routeDogsLivery(page: CheckOutPage()));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithOutProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SvgPicture.asset('Assets/empty-cart.svg', height: 400),
          TextDogsLivery(
            text: 'Sem produtos',
            fontSize: 21,
            fontWeight: FontWeight.w500,
            color: ColorsDogsLivery.primaryColor,
          )
        ],
      ),
    );
  }
}
