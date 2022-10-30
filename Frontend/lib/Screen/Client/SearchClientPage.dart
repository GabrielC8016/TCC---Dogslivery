// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors, prefer_is_empty, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dogslivery/Bloc/Products/products_bloc.dart';
import 'package:dogslivery/Controller/ProductsController.dart';
import 'package:dogslivery/Models/Response/ProductsTopHomeResponse.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Client/DetailsProductPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/BottomNavigationDogsLivery.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class SearchClientPage extends StatefulWidget {
  @override
  _SearchClientPageState createState() => _SearchClientPageState();
}

class _SearchClientPageState extends State<SearchClientPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductsBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushReplacement(
                        context, routeDogsLivery(page: ClientHomePage())),
                    child: Container(
                      height: 44,
                      child: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.0)),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          productBloc.add(OnSearchProductEvent(value));
                          if (value.length != 0)
                            productController.searchProductsForName(value);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Procurar Produtos',
                            hintStyle: GoogleFonts.getFont('Inter',
                                color: Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (_, state) => Expanded(
                    child: (state.searchProduct.length != 0)
                        ? listProducts()
                        : _HistorySearch()),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationDogsLivery(1),
    );
  }

  Widget listProducts() {
    return StreamBuilder<List<Productsdb>>(
        stream: productController.searchProducts,
        builder: (context, snapshot) {
          if (snapshot.data == null) return _HistorySearch();

          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data!.length == 0) {
            return ListTile(
              title: TextDogsLivery(
                  text: 'Sem resultados para ${_searchController.text}'),
            );
          }

          final listProduct = snapshot.data!;

          return _ListProductSearch(listProduct: listProduct);
        });
  }
}

class _ListProductSearch extends StatelessWidget {
  final List<Productsdb> listProduct;

  const _ListProductSearch({required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listProduct.length,
        itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    routeDogsLivery(
                        page: DetailsProductPage(product: listProduct[i]))),
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                scale: 8,
                                image: NetworkImage(
                                    URLS.BASE_URL + listProduct[i].picture))),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextDogsLivery(text: listProduct[i].nameProduct),
                            SizedBox(height: 5.0),
                            TextDogsLivery(
                                text: '\$ ${listProduct[i].price}',
                                color: Colors.grey),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}

class _HistorySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextDogsLivery(
            text: 'PESQUISA RECENTE', fontSize: 16, color: Colors.grey),
        SizedBox(height: 10.0),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          minLeadingWidth: 20,
          leading: Icon(Icons.history),
          title: TextDogsLivery(text: 'Ração', color: Colors.grey),
        )
      ],
    );
  }
}
