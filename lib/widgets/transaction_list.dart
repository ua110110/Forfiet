import 'package:flutter/material.dart';

import '../widgets/transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
 final List<Transaction> transactions ;
final Function deleteTx ;
final where ;
// Future refresh ;
 TransactionList (this.transactions , this.deleteTx , this.where );
 
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
                return TransactionItem(transactions: transactions[index], deleteTx: deleteTx , index: index ,where: where);
              }, 
                itemCount: transactions.length,   
      
    );
  }
}

