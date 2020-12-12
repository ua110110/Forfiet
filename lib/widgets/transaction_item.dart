import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/recentlyDeleted.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transactions,
    @required this.deleteTx,
    @required this.index,
    @required this.where, 
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTx;
  final int index ;
  final String where ;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical:8 ,
        horizontal:5
        ),
      child: ListTile(
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
              title: Text(
                transactions.title,
                style: Theme.of(context).textTheme.title
      ),
      subtitle: Text(
        DateFormat.yMMMd().format(transactions.date,
        ),
      
      ),

      trailing: MediaQuery.of(context).size.width>460 ? 
        FlatButton.icon(
          onPressed: () {
          deleteTx(transactions.id);
          final addin = Provider.of<RecenltyDeleted>(context) ;
             addin.addItem(
           where, 
          index ,
          Transaction(
          id: transactions.id,
          amount: transactions.amount,
          title: transactions.title,
          date: transactions.date
          ),
          );
         
          
        }, 
          textColor:Theme.of(context).errorColor ,
          icon: const Icon(Icons.delete), 
          label: const Text('Delete'))
        : IconButton(
        icon: Icon(Icons.delete),
        color: Theme.of(context).errorColor,
        onPressed: () {
          deleteTx(transactions.id);
           final addin = Provider.of<RecenltyDeleted>(context) ;
          addin.addItem(
          where, 
          index ,
          Transaction(
          id: transactions.id,
          amount: transactions.amount,
          title: transactions.title,
          date:transactions.date
          ),
          );
        },
        ),
    )
    );
  }
}