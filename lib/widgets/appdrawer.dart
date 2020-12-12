import 'package:flutter/material.dart';
import '../main.dart';
//import 'package:forfeit/screens/allcopy.dart';
import '../screens/all_transactions_screen.dart';
import '../providers/auth.dart';
import '../screens/othersMoney_screen.dart';
import '../screens/recentlyDeleted_screen.dart';
import 'package:provider/provider.dart';

import '../screens/money_i_give_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget> [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Daily Expenses'),
              onTap: () async {
                 await Navigator.of(context).pushReplacementNamed('/');
          //    await Navigator.of(context).pushNamed(MyHomePage.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sentiment_very_satisfied),
              title: Text('My Money'),
              onTap: () async {
               await Navigator.of(context).pushNamed(MyMoney.routeName);
              //  await Navigator.of(context).pushNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sentiment_very_dissatisfied),
              title: Text('Others Money'),
              onTap: () async {
              await  Navigator.of(context).pushNamed(OtherMoney.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Recently Deleted'),
              onTap: () async{
              await Navigator.of(context).pushNamed(DeletedClass.routeName);
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.delete),
            //   title: Text('RCopy'),
            //   onTap: () async{
            //   await Navigator.of(context).pushNamed(MyHomePagecopy.routeName);
            //   },
            // ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () async {
               // Navigator.of(context).pushReplacementNamed('/');
              await Provider.of<Auth>(context).logout();
              },
            ),
            ]
      )
       );
  }
}