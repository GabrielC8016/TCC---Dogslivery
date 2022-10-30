// ignore_for_file: prefer_const_constructors, prefer_is_empty, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Models/Response/OrdersClientResponse.dart';
import 'package:dogslivery/Screen/Client/ClientDetailsOrderPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class ClientOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextDogsLivery(text: 'Meus Pedidos', fontSize: 20),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: ColorsDogsLivery.primaryColor, size: 17),
              TextDogsLivery(
                  text: 'Voltar',
                  fontSize: 17,
                  color: ColorsDogsLivery.primaryColor)
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<OrdersClient>?>(
          future: ordersController.getListOrdersForClient(),
          builder: (context, snapshot) => (!snapshot.hasData)
              ? Column(
                  children: [
                    ShimmerDogsLivery(),
                    SizedBox(height: 10.0),
                    ShimmerDogsLivery(),
                    SizedBox(height: 10.0),
                    ShimmerDogsLivery(),
                  ],
                )
              : _ListOrdersClient(listOrders: snapshot.data!)),
    );
  }
}

class _ListOrdersClient extends StatelessWidget {
  final List<OrdersClient> listOrders;

  const _ListOrdersClient({required this.listOrders});

  @override
  Widget build(BuildContext context) {
    return (listOrders.length != 0)
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            itemCount: listOrders.length,
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  routeDogsLivery(
                      page:
                          ClientDetailsOrderPage(orderClient: listOrders[i]))),
              child: Container(
                margin: EdgeInsets.only(bottom: 20.0),
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextDogsLivery(
                            text: 'Pedido # ${listOrders[i].id}',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColorsDogsLivery.primaryColor),
                        TextDogsLivery(
                            text: listOrders[i].status!,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: (listOrders[i].status == 'ENTREGUE'
                                ? ColorsDogsLivery.primaryColor
                                : ColorsDogsLivery.secundaryColor)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextDogsLivery(
                            text: 'Quantidade',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        TextDogsLivery(
                            text: '\$ ${listOrders[i].amount}0', fontSize: 16)
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextDogsLivery(
                            text: 'Data',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        TextDogsLivery(
                            text: DateDogsLivery.getDateOrder(
                                listOrders[i].currentDate.toString(),
                                fontSize: 15))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SvgPicture.asset('Assets/empty-cart.svg');
  }
}
