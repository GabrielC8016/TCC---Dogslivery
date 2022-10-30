import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Products/products_bloc.dart';
import 'package:dogslivery/Controller/ProductsController.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Models/Response/ProductsTopHomeResponse.dart';
import 'package:dogslivery/Screen/Admin/Products/AddNewProductPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';


class ListProductsPage extends StatefulWidget {
  @override
  State<ListProductsPage> createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        
        if( state is LoadingProductsState ){

          modalLoading(context);

        }else if( state is SuccessProductsState ){

          Navigator.pop(context);
          modalSuccess(context, 'Sucesso', (){
            Navigator.pop(context);
            setState(() {});
          });

        } else if ( state is FailureProductsState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextDogsLivery(text: 'Lista de Produtos', fontSize: 19),
          centerTitle: true,
          leadingWidth: 80,
          elevation: 0,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded, color: ColorsDogsLivery.primaryColor, size: 17),
                TextDogsLivery(text: 'Voltar', fontSize: 17, color: ColorsDogsLivery.primaryColor)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(context, routeDogsLivery(page: AddNewProductPage())),
              child: TextDogsLivery(text: 'Adicionar', fontSize: 17, color: ColorsDogsLivery.primaryColor)
            )
          ],
        ),
        body: FutureBuilder<List<Productsdb>>(
          future: productController.listProductsAdmin(),
          builder: (context, snapshot) 
            => ( !snapshot.hasData )
              ? ShimmerDogsLivery()
              : _GridViewListProduct(listProducts: snapshot.data!)
           
        ),
      ),
    );
  }
}

class _GridViewListProduct extends StatelessWidget {
  
  final List<Productsdb> listProducts;

  const _GridViewListProduct({required this.listProducts});

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      itemCount: listProducts.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20
      ), 
      itemBuilder: (context, i) 
        => InkWell(
          onTap: () => modalActiveOrInactiveProduct(context, listProducts[i].status, listProducts[i].nameProduct, listProducts[i].id, listProducts[i].picture),
          onLongPress: () => modalDeleteProduct(context, listProducts[i].nameProduct, listProducts[i].picture, listProducts[i].id.toString()),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    scale: 7,
                    image: NetworkImage( URLS.BASE_URL + listProducts[i].picture)
                  )
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: ( listProducts[i].status == 1 ) ? Colors.grey[50] : Colors.red[100]
                  ),
                  child: TextDogsLivery(text: listProducts[i].nameProduct, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
    );  

  }



}