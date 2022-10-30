// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Helpers/DogsLiveryIndicator.dart';
import 'package:dogslivery/Models/PayType.dart';
import 'package:dogslivery/Models/Response/OrdersByStatusResponse.dart';
import 'package:dogslivery/Screen/Admin/OrdersAdmin/OrderDetailsPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class OrdersAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: payType.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: TextDogsLivery(text: 'Listar Pedidos', fontSize: 20),
            centerTitle: true,
            leadingWidth: 80,
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_new_outlined,
                      color: ColorsDogsLivery.primaryColor, size: 17),
                  TextDogsLivery(
                      text: 'Voltar',
                      color: ColorsDogsLivery.primaryColor,
                      fontSize: 17)
                ],
              ),
            ),
            bottom: TabBar(
                indicatorWeight: 2,
                labelColor: ColorsDogsLivery.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicator: DogsLiveryIndicatorTabBar(),
                isScrollable: true,
                tabs: List<Widget>.generate(
                    payType.length,
                    (i) => Tab(
                        child: Text(payType[i],
                            style:
                                GoogleFonts.getFont('Roboto', fontSize: 17))))),
          ),
          body: TabBarView(
            children: payType
                .map((e) => FutureBuilder<List<OrdersResponse>?>(
                    future: ordersController.getOrdersByStatus(e),
                    builder: (context, snapshot) => (!snapshot.hasData)
                        ? Column(
                            children: [
                              ShimmerDogsLivery(),
                              SizedBox(height: 10),
                              ShimmerDogsLivery(),
                              SizedBox(height: 10),
                              ShimmerDogsLivery(),
                            ],
                          )
                        : _ListOrders(listOrders: snapshot.data!)))
                .toList(),
          ),
        ));
  }
}

class _ListOrders extends StatelessWidget {
  final List<OrdersResponse> listOrders;

  const _ListOrders({required this.listOrders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOrders.length,
      itemBuilder: (context, i) => _CardOrders(orderResponse: listOrders[i]),
    );
  }
}

class _CardOrders extends StatelessWidget {
  final OrdersResponse orderResponse;

  const _CardOrders({required this.orderResponse});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.blueGrey, blurRadius: 8, spreadRadius: -5)
          ]),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => Navigator.push(context,
            routeDogsLivery(page: OrderDetailsPage(order: orderResponse))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextDogsLivery(text: 'ID DO PEDIDO: ${orderResponse.orderId}'),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDogsLivery(
                      text: 'DATA',
                      fontSize: 16,
                      color: ColorsDogsLivery.secundaryColor),
                  TextDogsLivery(
                      text: DateDogsLivery.getDateOrder(
                          orderResponse.currentDate.toString(),
                          fontSize: 16)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDogsLivery(
                      text: 'Cliente',
                      fontSize: 16,
                      color: ColorsDogsLivery.secundaryColor),
                  TextDogsLivery(text: orderResponse.cliente!, fontSize: 16),
                ],
              ),
              SizedBox(height: 10.0),
              TextDogsLivery(
                  text: 'Endereço de Envio',
                  fontSize: 16,
                  color: ColorsDogsLivery.secundaryColor),
              SizedBox(height: 5.0),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextDogsLivery(
                      text: orderResponse.reference!,
                      fontSize: 16,
                      maxLine: 2)),
              SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
