import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Screens/products_overview_screen.dart';
import './Screens/product_detail_screen.dart';
import './Screens/cart_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './Screens/orders_screen.dart';
import './Screens/user_products_screen.dart';
import './Screens/edit_product_screen.dart';
import './Screens/auth_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (ctx, auth, previousProducts) => ProductsProvider(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
/*
            create: (ctx) => ProductsProvider(),
*/
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Shop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
