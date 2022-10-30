// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'package:dogslivery/Services/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Controller/ProductsController.dart';
import 'package:dogslivery/Models/Response/ProductsTopHomeResponse.dart';
import 'package:dogslivery/Screen/Client/DetailsProductPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/StaggeredDualView.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class SearchForCategoryPage extends StatelessWidget {
  final int idCategory;
  final String category;

  const SearchForCategoryPage(
      {Key? key, required this.idCategory, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextDogsLivery(
            text: category, fontSize: 20, fontWeight: FontWeight.w500),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: FutureBuilder<List<Productsdb>>(
            future: productController
                .searchPorductsForCategory(idCategory.toString()),
            builder: (context, snapshot) => (!snapshot.hasData)
                ? ShimmerDogsLivery()
                : ListProducts(listProduct: snapshot.data!)),
      ),
    );
  }
}

class ListProducts extends StatelessWidget {
  final List<Productsdb> listProduct;

  const ListProducts({Key? key, required this.listProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (listProduct.length != 0)
        ? StaggeredDualView(
            spacing: 15,
            alturaElement: 0.14,
            aspectRatio: 0.78,
            itemCount: listProduct.length,
            itemBuilder: (context, i) => Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DetailsProductPage(product: listProduct[i]))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Hero(
                              tag: listProduct[i].id,
                              child: Image.network(
                                  URLS.URL_API + listProduct[i].picture,
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
                ))
        : _withoutProducts();
  }

  Widget _withoutProducts() {
    return Container(
      child: Column(
        children: [
          SvgPicture.asset('Assets/empty-cart.svg', height: 450),
          TextDogsLivery(
              text: 'Sem produtos',
              fontSize: 21,
              color: ColorsDogsLivery.primaryColor)
        ],
      ),
    );
  }
}
