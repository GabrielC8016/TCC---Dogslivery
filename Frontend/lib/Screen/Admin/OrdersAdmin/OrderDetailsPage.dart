// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Orders/orders_bloc.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Helpers/Date.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Models/Response/OrderDetailsResponse.dart';
import 'package:dogslivery/Models/Response/OrdersByStatusResponse.dart';
import 'package:dogslivery/Screen/Admin/OrdersAdmin/OrdersAdminPage.dart';
import 'package:dogslivery/Services/url.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrdersResponse order;

  const OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is LoadingOrderState) {
          modalLoading(context);
        } else if (state is SuccessOrdersState) {
          Navigator.pop(context);
          modalSuccess(
              context,
              'DESPACHOU',
              () => Navigator.pushReplacement(
                  context, routeDogsLivery(page: OrdersAdminPage())));
        } else if (state is FailureOrdersState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextDogsLivery(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextDogsLivery(text: 'Pedido N° ${order.orderId}'),
          centerTitle: true,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 17, color: ColorsDogsLivery.primaryColor),
                TextDogsLivery(
                    text: 'Voltar',
                    color: ColorsDogsLivery.primaryColor,
                    fontSize: 17)
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: FutureBuilder<List<DetailsOrder>?>(
                    future: ordersController
                        .gerOrderDetailsById(order.orderId.toString()),
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
                        : _ListProductsDetails(
                            listProductDetails: snapshot.data!))),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'Total',
                          color: ColorsDogsLivery.secundaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                      TextDogsLivery(
                          text: '\$ ${order.amount}0',
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'Cliente:',
                          color: ColorsDogsLivery.secundaryColor,
                          fontSize: 16),
                      TextDogsLivery(text: '${order.cliente}'),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDogsLivery(
                          text: 'DATA:',
                          color: ColorsDogsLivery.secundaryColor,
                          fontSize: 16),
                      TextDogsLivery(
                          text: DateDogsLivery.getDateOrder(
                              order.currentDate.toString(),
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextDogsLivery(
                      text: 'Endereço de Envio:',
                      color: ColorsDogsLivery.secundaryColor,
                      fontSize: 16),
                  SizedBox(height: 5.0),
                  TextDogsLivery(
                      text: order.reference!, maxLine: 2, fontSize: 16),
                  SizedBox(height: 5.0),
                  (order.status == 'DESPACHOU')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextDogsLivery(
                                text: 'Entrega',
                                fontSize: 17,
                                color: ColorsDogsLivery.secundaryColor),
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(URLS.BASE_URL +
                                              order.deliveryImage!))),
                                ),
                                SizedBox(width: 10.0),
                                TextDogsLivery(
                                    text: order.delivery!, fontSize: 17)
                              ],
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            )),
            (order.status == 'PAGO')
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BtnDogsLivery(
                          text: 'SELECIONAR ENTREGA',
                          fontWeight: FontWeight.w500,
                          onPressed: () => modalSelectDelivery(
                              context, order.orderId.toString()),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class _ListProductsDetails extends StatelessWidget {
  final List<DetailsOrder> listProductDetails;

  const _ListProductsDetails({required this.listProductDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: listProductDetails.length,
      separatorBuilder: (_, index) => Divider(),
      itemBuilder: (_, i) => Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          URLS.BASE_URL + listProductDetails[i].picture!))),
            ),
            SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextDogsLivery(
                    text: listProductDetails[i].nameProduct!,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 5.0),
                TextDogsLivery(
                    text: 'Quantidade: ${listProductDetails[i].quantity}',
                    color: Colors.grey,
                    fontSize: 17),
              ],
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: TextDogsLivery(text: '\$ ${listProductDetails[i].total}'),
            ))
          ],
        ),
      ),
    );
  }
}
