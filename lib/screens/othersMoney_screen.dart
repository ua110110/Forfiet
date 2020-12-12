import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/othermoney.dart';
import '../widgets/transaction_list.dart';
import '../widgets/appdrawer.dart';


class OtherMoney extends StatefulWidget {
  
 // String titleInput ;
//  String amountInput;

static const routeName = '/Other-Money';

  @override
  _OtherMoneyState createState() => _OtherMoneyState();
}

class _OtherMoneyState extends State<OtherMoney> {
   final titleController  = TextEditingController();

   final amountController  = TextEditingController();
   var _isinIt = true ;
    var _isLoading = true ;

     Future <void> _refreshProductsmain(BuildContext context) async {
    await Provider.of<OM>(context).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      Provider.of<OM>(context).fetchAndSetProducts().then((_) {
         setState(() {
           _isLoading = false ;
         });
      });
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context) ;
    final om = Provider.of<OM>(context) ;
   final isLandscape = mediaQuery.orientation == Orientation.landscape ;
      final PreferredSizeWidget appBar = Platform.isIOS ?
      CupertinoNavigationBar(
        middle: Text('Other Money'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              
              child: Icon(CupertinoIcons.add),
              onTap: () =>om.startAddNewTransaction(context) ,
            )
          ]
        ),
      )
      : AppBar(
        title: Text('Other Money'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed:() => om.startAddNewTransaction(context),
              ),
          ],
      ) ;
      final txListWidget =  Container(
             height: (mediaQuery.size.height-
              appBar.preferredSize.height-
              mediaQuery.padding.top)*0.9,
             child: TransactionList(om.othermoney , om.deleteTransaction , 'othermoney')
             );
      final pageBody =  SafeArea(child: SingleChildScrollView(
          child: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding:EdgeInsets.all(8) ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Total Amount' , style: TextStyle(fontSize: 20) ,),
                  Spacer(),
                  Chip(label: Text('₹${om.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              ),
              ),
          ...[
            //  TransactionList(_mymoney , _deleteTransaction)
            txListWidget
               ],
          ],
        ),
      ),);       
      return Platform.isIOS ? 
      CupertinoPageScaffold(
        child: pageBody,
        navigationBar: appBar,
      ) 
      : Scaffold(
      appBar: appBar ,
      drawer: AppDrawer() ,
      body: RefreshIndicator(
        onRefresh:() {
          return _refreshProductsmain(context);
        } ,
        child:_isLoading ? Center(
        child : CircularProgressIndicator(),
      ) : pageBody ,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Platform.isIOS ?
      Container() 
      :FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => om.startAddNewTransaction(context),
        ),
    );
  }
}