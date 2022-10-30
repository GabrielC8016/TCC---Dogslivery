// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, curly_braces_in_flow_control_structures, duplicate_ignore

import 'package:dogslivery/Services/url.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Cart/cart_bloc.dart';
import 'package:dogslivery/Controller/ProductsController.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Models/ProductCart.dart';
import 'package:dogslivery/Models/Response/ImagesProductsResponse.dart';
import 'package:dogslivery/Models/Response/ProductsTopHomeResponse.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class DetailsProductPage extends StatefulWidget {
  final Productsdb product;

  const DetailsProductPage({required this.product});

  @override
  _DetailsProductPageState createState() => _DetailsProductPageState();
}

class _DetailsProductPageState extends State<DetailsProductPage> {
  bool isLoading = false;
  List<ImageProductdb> imagesProducts = [];

  _getImageProducts() async {
    imagesProducts =
        await productController.getImagesProducts(widget.product.id.toString());
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    _getImageProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartBloc = BlocProvider.of<CartBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isLoading)
                ? Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 360,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey[50],
                                // ignore: prefer_const_constructors
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0))),
                            child: Hero(
                              tag: widget.product.id,
                              child: Container(
                                height: 180,
                                child: CarouselSlider.builder(
                                  itemCount: imagesProducts.length,
                                  options: CarouselOptions(
                                      viewportFraction: 1.0, autoPlay: true),
                                  itemBuilder: (context, i, realIndex) =>
                                      Container(
                                    width: size.width,
                                    child: Image.network(URLS.BASE_URL +
                                        imagesProducts[i].picture),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                cartBloc.add(OnResetQuantityEvent());
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(Icons.arrow_back_ios_new_rounded,
                                    size: 20),
                              ),
                            ),
                            TextDogsLivery(
                                text: 'Detalhes',
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(Icons.favorite_border_outlined,
                                  size: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : ShimmerDogsLivery(),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: ColorsDogsLivery.primaryColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 3.0),
                        TextDogsLivery(
                            text: '5.0', color: Colors.white, fontSize: 17)
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 18),
                      SizedBox(width: 5.0),
                      TextDogsLivery(text: '30 Min'),
                    ],
                  ),
                  TextDogsLivery(text: '\$ Frete grátis')
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                child: TextDogsLivery(
                    text: widget.product.nameProduct,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                child: TextDogsLivery(
                    text: widget.product.description,
                    fontSize: 18,
                    color: Colors.grey,
                    maxLine: 5),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
                child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (state.quantity > 1)
                                        cartBloc.add(
                                            OnDecreaseProductQuantityEvent());
                                    }),
                                SizedBox(width: 10.0),
                                TextDogsLivery(
                                    text: state.quantity.toString(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                SizedBox(width: 10.0),
                                IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(Icons.add),
                                    onPressed: () => cartBloc
                                        .add(OnIncreaseProductQuantityEvent())),
                              ],
                            ),
                          ),
                        ),
                        (widget.product.status == 1)
                            ? Container(
                                height: 50,
                                width: 220,
                                decoration: BoxDecoration(
                                    color: ColorsDogsLivery.primaryColor,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      child: TextDogsLivery(
                                          text: 'Carrinho:',
                                          color: Colors.white,
                                          fontSize: 17),
                                      onPressed: () {
                                        final newProduct = ProductCart(
                                            uidProduct:
                                                widget.product.id.toString(),
                                            imageProduct:
                                                widget.product.picture,
                                            nameProduct:
                                                widget.product.nameProduct,
                                            price: widget.product.price,
                                            quantity: cartBloc.state.quantity);
                                        cartBloc.add(OnAddProductToCartEvent(
                                            newProduct));
                                        modalSuccess(
                                            context,
                                            'Produto Adicionado',
                                            () => Navigator.pop(context));
                                      },
                                    ),
                                    SizedBox(width: 5.0),
                                    BlocBuilder<CartBloc, CartState>(
                                        builder: (context, state) => TextDogsLivery(
                                            text:
                                                '\$${widget.product.price * state.quantity}',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16))
                                  ],
                                ))
                            : Container(
                                height: 50,
                                width: 220,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.sentiment_dissatisfied_rounded,
                                        color: Colors.white, size: 30),
                                    SizedBox(width: 5.0),
                                    TextDogsLivery(
                                        text: 'VENDIDO',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
