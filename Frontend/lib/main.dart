import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dogslivery/Bloc/Auth/auth_bloc.dart';
import 'package:dogslivery/Bloc/Cart/cart_bloc.dart';
import 'package:dogslivery/Bloc/Delivery/delivery_bloc.dart';
import 'package:dogslivery/Bloc/General/general_bloc.dart';
import 'package:dogslivery/Bloc/MapClient/mapclient_bloc.dart';
import 'package:dogslivery/Bloc/MapDelivery/mapdelivery_bloc.dart';
import 'package:dogslivery/Bloc/My%20Location/mylocationmap_bloc.dart';
import 'package:dogslivery/Bloc/Orders/orders_bloc.dart';
import 'package:dogslivery/Bloc/Payments/payments_bloc.dart';
import 'package:dogslivery/Bloc/Products/products_bloc.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Screen/Intro/CheckingLoginPage.dart';
import 'package:dogslivery/Services/PushNotification.dart';

PushNotification pushNotification = PushNotification();

Future<void> _firebaseMessagingBackground(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAt-MbNUoidY0f-lTdLhoqxi4yncpgIRTE",
      appId: "1:82108069968:android:7adca60bf05956d539f955",
      messagingSenderId: "82108069968",
      projectId: "dogslivery-59dd1",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackground);
  pushNotification.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    pushNotification.onMessagingListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckLoginEvent())),
        BlocProvider(create: (context) => GeneralBloc()),
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => MylocationmapBloc()),
        BlocProvider(create: (context) => PaymentsBloc()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => DeliveryBloc()),
        BlocProvider(create: (context) => MapdeliveryBloc()),
        BlocProvider(create: (context) => MapclientBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DogsLivery',
        home: CheckingLoginPage(),
      ),
    );
  }
}
