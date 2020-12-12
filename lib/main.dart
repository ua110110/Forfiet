import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:forfeit/screens/allcopy.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/othermoney.dart';
import './screens/othersMoney_screen.dart';
import './providers/mymoney.dart';
import './providers/daillytran.dart';
import './screens/recentlyDeleted_screen.dart';
import './providers/recentlyDeleted.dart';
import './screens/money_i_give_screen.dart';
import './screens/all_transactions_screen.dart';




void main() {
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
           value: Auth(),
           ),
          ChangeNotifierProxyProvider<Auth, MM>(
          builder: (ctx, auth, previousProducts) => MM(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.mymoney,
              ),
        ),
           ChangeNotifierProxyProvider<Auth, DailyTransactions>(
          builder: (ctx, auth, previousProducts) => DailyTransactions(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.userTransaction,
              ),
        ),
          ChangeNotifierProxyProvider<Auth, OM>(
          builder: (ctx, auth, previousProducts) => OM(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.othermoney,
              ),
            
        ),
         ChangeNotifierProxyProvider<Auth, RecenltyDeleted>(
          builder: (ctx, auth, previousProducts) => RecenltyDeleted(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.recentlydeleted,
              ),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx , auth ,_) => MaterialApp(
          title: 'Daily Expenses',
          theme: ThemeData(
            primarySwatch: Colors.purple , 
            accentColor: Colors.amber ,
            errorColor: Colors.red,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                 title: TextStyle(
                   fontFamily: 'OpenSans',
                   fontWeight: FontWeight.bold,
                   fontSize: 18,
                   ),
                   button: TextStyle(color: Colors.white)
                    ), 
            appBarTheme: AppBarTheme(
               textTheme: ThemeData.light().textTheme.copyWith(
                 title: TextStyle(
                   fontFamily: 'OpenSans',
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                   ) ),
            ),
          ),
          home: auth.isAuth
                    ? MyHomePage()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
          routes: {
            OtherMoney.routeName: (ctx) => OtherMoney() ,
            MyMoney.routeName: (ctx) => MyMoney() ,
            DeletedClass.routeName: (ctx) => DeletedClass() ,
      //     MyHomePage.routeName: (ctx) => MyHomePage() ,
    //        MyHomePagecopy.routeName: (ctx) => MyHomePagecopy() ,
          },
        ),
      ),
    );
  }
}

