// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Bloc/Cart/cart_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Controller/CategoryController.dart';
import 'package:dogslivery/Controller/ProductsController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Models/Response/CategoryAllResponse.dart';
import 'package:dogslivery/Models/Response/ProductsTopHomeResponse.dart';
import 'package:dogslivery/Screen/Client/CartClientPage.dart';
import 'package:dogslivery/Screen/Client/DetailsProductPage.dart';
import 'package:dogslivery/Screen/Client/SearchForCategoryPage.dart';
import 'package:dogslivery/Screen/Profile/ListAddressesPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/BottomNavigationDogsLivery.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class ClientHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(URLS.BASE_URL +
                                  '' +
                                  authBloc.state.user!.image.toString()))),
                    ),
                    SizedBox(width: 8.0),
                    TextDogsLivery(
                        text: DateDogsLivery.getDateDogsLivery() +
                            ', ${authBloc.state.user!.firstName}',
                        fontSize: 17,
                        color: ColorsDogsLivery.secundaryColor),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pushReplacement(
                      context, routeDogsLivery(page: CartClientPage())),
                  child: Stack(
                    children: [
                      Container(
                        child: Icon(Icons.shopping_bag_outlined, size: 30),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 5,
                        child: Container(
                            height: 20,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Color(0xff0C6CF2),
                                shape: BoxShape.circle),
                            child: Center(
                                child: BlocBuilder<CartBloc, CartState>(
                                    builder: (context, state) => TextDogsLivery(
                                        text: state.quantityCart.toString(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)))),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Container(
                padding: EdgeInsets.only(right: 50.0),
                child: TextDogsLivery(
                    text: 'Qual será o pedido do seu bichinho hoje?',
                    fontSize: 28,
                    maxLine: 2,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 20.0),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(15.0)),
                  child:
                      Icon(Icons.place_outlined, size: 38, color: Colors.grey),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDogsLivery(text: 'Endereço'),
                    InkWell(
                      onTap: () => Navigator.push(
                          context, routeDogsLivery(page: ListAddressesPage())),
                      child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) => TextDogsLivery(
                                text: (state.addressName != '')
                                    ? state.addressName
                                    : 'Sem Endereço',
                                color: ColorsDogsLivery.primaryColor,
                                fontSize: 17,
                                maxLine: 1,
                              )),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20.0),
            FutureBuilder<List<Category>>(
              future: categoryController.getAllCategories(),
              builder: (context, snapshot) {
                final List<Category>? category = snapshot.data;

                return !snapshot.hasData
                    ? ShimmerDogsLivery()
                    : Container(
                        height: 45,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: category!.length,
                          itemBuilder: (context, i) => InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.push(
                                context,
                                routeDogsLivery(
                                    page: SearchForCategoryPage(
                                        idCategory: category[i].id,
                                        category: category[i].category))),
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10.0),
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xff5469D4).withOpacity(.1),
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: TextDogsLivery(text: category[i].category),
                            ),
                          ),
                        ),
                      );
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextDogsLivery(
                    text: 'Itens populares',
                    fontSize: 21,
                    fontWeight: FontWeight.w500),
                TextDogsLivery(
                    text: 'Ver tudo',
                    color: ColorsDogsLivery.primaryColor,
                    fontSize: 17)
              ],
            ),
            SizedBox(height: 20.0),
            _ListProducts(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationDogsLivery(0),
    );
  }
}

class _ListProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Productsdb>>(
      future: productController.getProductsTopHome(),
      builder: (_, snapshot) {
        final List<Productsdb>? listProduct = snapshot.data;

        return !snapshot.hasData
            ? Column(
                children: [
                  ShimmerDogsLivery(),
                  SizedBox(height: 10.0),
                  ShimmerDogsLivery(),
                  SizedBox(height: 10.0),
                  ShimmerDogsLivery(),
                ],
              )
            : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 220),
                itemCount: listProduct?.length,
                itemBuilder: (_, i) => Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DetailsProductPage(product: listProduct![i]))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Hero(
                              tag: listProduct![i].id,
                              child: Image.network(
                                  URLS.BASE_URL + listProduct[i].picture,
                                  height: 150)),
                        ),
                        TextDogsLivery(
                            text: listProduct[i].nameProduct,
                            textOverflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: ColorsDogsLivery.primaryColor,
                            fontSize: 19),
                        SizedBox(height: 5.0),
                        TextDogsLivery(
                            text: '\$ ${listProduct[i].price.toString()}',
                            fontSize: 16,
                            fontWeight: FontWeight.w500)
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
