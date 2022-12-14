// ignore_for_file: unused_element

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:dogslivery/Controller/OrdersController.dart';
import 'package:dogslivery/Controller/UserController.dart';
import 'package:dogslivery/Models/ProductCart.dart';
import 'package:dogslivery/main.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersState()) {
    on<OnAddNewOrdersEvent>(_onAddNewOrders);
    on<OnUpdateStatusOrderToDispatchedEvent>(_onUpdateStatusOrderToDispatched);
    on<OnUpdateStatusOrderOnWayEvent>(_onUpdateStatusOrderOnWay);
    on<OnUpdateStatusOrderDeliveredEvent>(_onUpdateStatusOrderDelivered);
    on<OnCancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onAddNewOrders(
      OnAddNewOrdersEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());

      await Future.delayed(Duration(milliseconds: 1500));

      final resp = await ordersController.addNewOrders(
          event.uidAddress, event.total, event.typePayment, event.products);

      if (resp.resp) {
        final listTokens = await userController.getAdminsNotificationToken();

        Map<String, dynamic> data = {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        };

        await pushNotification.sendNotificationMultiple(
            listTokens, data, 'Compra Realizada', 'Você Tem Um Novo Pedido');

        emit(SuccessOrdersState());
      } else {
        emit(FailureOrdersState(resp.msg));
      }
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onUpdateStatusOrderToDispatched(
      OnUpdateStatusOrderToDispatchedEvent event,
      Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());

      final resp = await ordersController.updateStatusOrderToDispatched(
          event.idOrder, event.idDelivery);

      await Future.delayed(Duration(seconds: 1));

      if (resp.resp) {
        Map<String, dynamic> data = {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        };

        await pushNotification.sendNotification(event.notificationTokenDelivery,
            data, 'Pedido Atribuído', 'Novo Pedido Atribuído');

        emit(SuccessOrdersState());
      } else {
        emit(FailureOrdersState(resp.msg));
      }
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onUpdateStatusOrderOnWay(
      OnUpdateStatusOrderOnWayEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());

      final resp = await ordersController.updateOrderStatusOnWay(
          event.idOrder,
          event.locationDelivery.latitude.toString(),
          event.locationDelivery.longitude.toString());

      await Future.delayed(Duration(seconds: 1));

      if (resp.resp)
        emit(SuccessOrdersState());
      else
        emit(FailureOrdersState(resp.msg));
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onUpdateStatusOrderDelivered(
      OnUpdateStatusOrderDeliveredEvent event,
      Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());

      final resp =
          await ordersController.updateOrderStatusDelivered(event.idOrder);

      await Future.delayed(Duration(milliseconds: 450));

      if (resp.resp)
        emit(SuccessOrdersState());
      else
        emit(FailureOrdersState(resp.msg));
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
      OnCancelOrderEvent event, Emitter<OrdersState> emit) async {
    try {
      emit(LoadingOrderState());

      final resp = await ordersController.cancelOrder(event.idOrder);

      await Future.delayed(Duration(seconds: 1));

      if (resp.resp) {
        final listTokens = await userController.getAdminsNotificationToken();

        Map<String, dynamic> data = {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        };

        await pushNotification.sendNotificationMultiple(
            listTokens,
            data,
            'Pedido #${event.idOrder} Cancelado',
            'Pedido #${event.idOrder} Cancelado');

        emit(SuccessOrdersState());
      } else {
        emit(FailureOrdersState(resp.msg));
      }
    } catch (e) {
      emit(FailureOrdersState(e.toString()));
    }
  }
}
