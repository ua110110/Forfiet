import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/recentlyDeleted.dart';
import '../models/transaction.dart';
import '../widgets/appdrawer.dart';
import '../models/delete.dart';
import '../providers/mymoney.dart';
import '../providers/othermoney.dart';
import '../providers/daillytran.dart';


class DeletedClass extends StatefulWidget {
  
 // String titleInput ;
//  String amountInput;
 static const routeName = '/deleting-class';
  @override
  _DeletedClassState createState() => _DeletedClassState();
}

class _DeletedClassState extends State<DeletedClass> {
  

// void _deleteTransaction(String id){
//    setState(() {
//      _mymoney.removeWhere((tx) {
//        return tx.id == id ;
//      });
//    });
// }

// void _clearall() {

// }

   var _isinIt = true ;
    var _isLoading = true ;

     Future <void> _refreshProductsmain(BuildContext context) async {
    await Provider.of<RecenltyDeleted>(context).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
   if(_isinIt){
     setState(() {
       _isLoading = true; 
     });
      Provider.of<RecenltyDeleted>(context).fetchAndSetProducts().then((_) {
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
    final deletedData = Provider.of<RecenltyDeleted>(context) ;
    final mediaQuery = MediaQuery.of(context) ;
   final isLandscape = mediaQuery.orientation == Orientation.landscape ;
      final PreferredSizeWidget appBar = Platform.isIOS ?
      CupertinoNavigationBar(
        middle: Text('Recently Deleted'),
      )
      : AppBar(
        title: Text('Recently Deleted'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed:() => deletedData.deleteAll(),
              ),
          ],
      ) ;
      final txListWidget =  Container(
             height: (mediaQuery.size.height-
              appBar.preferredSize.height-
              mediaQuery.padding.top)*1,
             child: TransactionList(deletedData.list() , deletedData.deleteone)
             );
      final pageBody =  SafeArea(child: SingleChildScrollView(
          child: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
      )
    );
  }
}

class TransactionList extends StatelessWidget {
 final List<Transaction> transactions ;
final Function deleteTx ;
 TransactionList (this.transactions , this.deleteTx);
 
  @override
  Widget build(BuildContext context) {
    return   
     transactions.isEmpty ? 
     LayoutBuilder(builder: (ctx, constraints){
       return  Column(children:<Widget>[
        Text(
          'No Transactions added yet!',
        style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: constraints.maxHeight*0.6,
          child: Image.asset('assets/images/waiting.png' ,
          fit: BoxFit.cover,)),
      ],) ;
     })
     :  ListView.builder(
              itemBuilder: (ctx, index){
                return Column(
                  children:<Widget> [ 
                    Divider(),
                    TransactionItem(transactions: transactions[index], deleteTx: deleteTx),
                    
                  ]
                );
                
              }, 
                itemCount: transactions.length,   
      
    );
  }
}


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transactions,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTx;
  
  @override
  Widget build(BuildContext context) {
    return ListTile( 
      title: Text(
                transactions.title,
                style: Theme.of(context).textTheme.title
      ),
      
      leading: CircleAvatar(
          backgroundColor: Colors.purple,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('₹${transactions.amount}') ,
              ),
              ),
              ),
              
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.assignment_return),
              onPressed: () {
                final rd = Provider.of<RecenltyDeleted>(context);
                Delete recovered = rd.recover(transactions.id) ;
                if(recovered.where== 'daily'){
                  final tr = Provider.of<DailyTransactions>(context);
                  tr.addNewTransaction(transactions.title, transactions.amount, transactions.date , recovered.index);
                }
                else if(recovered.where== 'mymoney'){
                  final tr = Provider.of<MM>(context);
                  tr.addNewTransaction(transactions.title, transactions.amount, transactions.date , recovered.index);
                }
                else if(recovered.where== 'othermoney'){
                  final tr = Provider.of<OM>(context);
                  tr.addNewTransaction(transactions.title, transactions.amount, transactions.date , recovered.index);
                }
                deleteTx(transactions.id) ;
              },
              color: Colors.blue,
              ),
              IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                 deleteTx(transactions.id) ;
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );

}
}