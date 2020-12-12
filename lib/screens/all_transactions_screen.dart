import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/daillytran.dart';
import '../widgets/chart.dart';
import '../widgets/transaction_list.dart';
import '../widgets/appdrawer.dart';


class MyHomePage extends StatefulWidget {
  
 // String titleInput ;
//  String amountInput;

 // static const routeName = '/Home-Page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final titleController  = TextEditingController();

   final amountController  = TextEditingController();
   
     bool _showChart = false ;
    var _isinIt = true ;
    var _isLoading = true ;
     
  Future <void> _refreshProductsmain(BuildContext context) async {
    await Provider.of<DailyTransactions>(context).fetchAndSetProducts();
  }
   
          
   @override
  void didChangeDependencies() {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      Provider.of<DailyTransactions>(context).fetchAndSetProducts().then((_) {
         setState(() {
           _isLoading = false ;
         });
      }
      );
   }
   _isinIt = false ;
    super.didChangeDependencies();
   }


  @override
  Widget build(BuildContext context) {
  //  _isinIt = true ;
    final ut = Provider.of<DailyTransactions>(context) ;
 //   ut.data();
    final mediaQuery = MediaQuery.of(context) ;
   final isLandscape = mediaQuery.orientation == Orientation.landscape ;
      final PreferredSizeWidget appBar = Platform.isIOS ?
      CupertinoNavigationBar(
        middle: Text('Daily Expenses'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              
              child: Icon(CupertinoIcons.add),
              onTap: () =>ut.startAddNewTransaction(context ) ,
            )
          ]
        ),
      )
      : AppBar(
        title: Text('Daily Expenses'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed:() => ut.startAddNewTransaction(context),
              ),
          ],
      ) ;
   //   ut.data() ;
      final txListWidget =  Container(
             height: (mediaQuery.size.height-
              appBar.preferredSize.height-
              mediaQuery.padding.top)*0.7,
             child: TransactionList(ut.userTransaction , ut.deleteTransaction , 'daily' )
             );
      final pageBody =  SafeArea(child: SingleChildScrollView(
          child: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          if (isLandscape)  
         ...[ Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text('Show Chart' , style: Theme.of(context).textTheme.title,),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, 
                  onChanged: (val){
                    setState(() {
                      _showChart = val ;
                     // notifyListeners() ;
                    });
                  },)
              ]
            ),
            _showChart ?
            Container(
              height: (mediaQuery.size.height-
              appBar.preferredSize.height-
              mediaQuery.padding.top)*0.71,
              child: Chart(ut.recentTransactions)
              )
              :
              txListWidget ],
            
          if (!isLandscape)
          ... [Container(
              height: (mediaQuery.size.height-
              appBar.preferredSize.height-
              mediaQuery.padding.top)*0.3,
              child: Chart(ut.recentTransactions)
              ),
              txListWidget ],
          ],
        ),
      ),
      );       
      return Platform.isIOS ? 
      CupertinoPageScaffold(
        child: pageBody,
        navigationBar: appBar,
      ) 
      : Scaffold(
      appBar: appBar ,
      drawer: AppDrawer() ,
     // body: pageBody,
      body:// RefreshIndicator(
        // onRefresh:() {
        //   return _refreshProductsmain(context);
        // } ,
        _isLoading ? Center(
        child : CircularProgressIndicator(),
      ) : 
      pageBody,
   //   ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Platform.isIOS ?
      Container() 
      :FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => ut.startAddNewTransaction(context),
        ),
    );
  }
}