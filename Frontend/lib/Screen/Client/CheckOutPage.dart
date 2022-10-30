// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Cart/cart_bloc.dart';
import 'package:dogslivery/Bloc/Orders/orders_bloc.dart';
import 'package:dogslivery/Bloc/Payments/payments_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Models/TypePayment.dart';
import 'package:dogslivery/Screen/Client/ClientHomePage.dart';
import 'package:dogslivery/Screen/Client/SelectAddreessPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class CheckOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderBloc = BlocProvider.of<OrdersBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final paymentBloc = BlocProvider.of<PaymentsBloc>(context);

    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is LoadingOrderState) {
          modalLoading(context);
        } else if (state is SuccessOrdersState) {
          Navigator.pop(context);
          modalSuccess(context, 'Pedido Recebido', () {
            cartBloc.add(OnClearCartEvent());
            paymentBloc.add(OnClearTypePaymentMethodEvent());
            Navigator.pushAndRemoveUntil(context,
                routeDogsLivery(page: ClientHomePage()), (route) => false);
          });
        } else if (state is FailureOrdersState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextDogsLivery(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          title: TextDogsLivery(text: 'Checkout', fontWeight: FontWeight.w500),
          centerTitle: true,
          elevation: 0,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: ColorsDogsLivery.primaryColor, size: 19),
                TextDogsLivery(
                    text: 'Voltar',
                    fontSize: 17,
                    color: ColorsDogsLivery.primaryColor)
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CheckoutAddress(),
                SizedBox(height: 20.0),
                _CheckoutPaymentMethods(),
                SizedBox(height: 20.0),
                _DetailsTotal(),
                SizedBox(height: 20.0),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<PaymentsBloc, PaymentsState>(
                        builder: (context, state) => InkWell(
                              onTap: () {
                                orderBloc.add(OnAddNewOrdersEvent(
                                    userBloc.state.uidAddress,
                                    cartBloc.state.total,
                                    paymentBloc.state.typePaymentMethod,
                                    cartBloc.product));

                                // if( state.typePaymentMethod == 'CREDIT CARD' ){

                                //   modalPaymentWithNewCard(ctx: context, amount: cartBloc.state.total.toString());

                                // }
                              },
                              child: Container(
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: state.colorPayment,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(state.iconPayment,
                                        color: Colors.white),
                                    SizedBox(width: 10.0),
                                    TextDogsLivery(
                                        text: state.typePaymentMethod,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                            ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardBloc = BlocProvider.of<CartBloc>(context);

    return Container(
      padding: EdgeInsets.all(15.0),
      height: 190,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDogsLivery(text: 'Resumo do Pedido', fontWeight: FontWeight.w500),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDogsLivery(text: 'Subtotal', color: Colors.grey),
              TextDogsLivery(
                  text: '\$ ${cardBloc.state.total}0', color: Colors.grey),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ignore: prefer_const_constructors
              TextDogsLivery(text: 'IGV', color: Colors.grey),
              TextDogsLivery(text: '\$ 2.5', color: Colors.grey),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDogsLivery(text: 'Envio', color: Colors.grey),
              TextDogsLivery(text: '\$ 0.00', color: Colors.grey),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDogsLivery(text: 'Total', fontWeight: FontWeight.w500),
              TextDogsLivery(
                  text: '\$ ${cardBloc.state.total}0',
                  fontWeight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckoutPaymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentBloc = BlocProvider.of<PaymentsBloc>(context);

    return Container(
      padding: EdgeInsets.all(15.0),
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDogsLivery(
                  text: 'Formas de Pagamento', fontWeight: FontWeight.w500),
              BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (_, state) => TextDogsLivery(
                      text: state.typePaymentMethod,
                      color: ColorsDogsLivery.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
            ],
          ),
          Divider(),
          SizedBox(height: 5.0),
          Container(
            height: 80,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: TypePaymentMethod.listTypePayment.length,
              itemBuilder: (_, i) => InkWell(
                onTap: () => paymentBloc.add(OnSelectTypePaymentMethodEvent(
                    TypePaymentMethod.listTypePayment[i].typePayment,
                    TypePaymentMethod.listTypePayment[i].icon,
                    TypePaymentMethod.listTypePayment[i].color)),
                child: BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (_, state) => Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                        color:
                            (TypePaymentMethod.listTypePayment[i].typePayment ==
                                    state.typePaymentMethod)
                                ? Color(0xffF7FAFC)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey[200]!)),
                    child: Icon(TypePaymentMethod.listTypePayment[i].icon,
                        size: 40,
                        color: TypePaymentMethod.listTypePayment[i].color),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CheckoutAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      height: 95,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDogsLivery(
                  text: 'Endereço para Envio', fontWeight: FontWeight.w500),
              InkWell(
                  onTap: () => Navigator.push(
                      context, routeDogsLivery(page: SelectAddressPage())),
                  child: TextDogsLivery(
                      text: 'Mudar Endereço',
                      color: ColorsDogsLivery.primaryColor,
                      fontSize: 17))
            ],
          ),
          Divider(),
          SizedBox(height: 5.0),
          BlocBuilder<UserBloc, UserState>(
              builder: (_, state) => TextDogsLivery(
                  text: (state.addressName != '')
                      ? state.addressName
                      : 'Selecionar endereço',
                  fontSize: 17,
                  maxLine: 1))
        ],
      ),
    );
  }
}
