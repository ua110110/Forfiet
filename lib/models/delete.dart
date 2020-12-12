import 'package:flutter/foundation.dart';

class Delete {
  final String where ;
  final int index ;
  final double amount ;
  final String title ;
  final DateTime date ;
  final String id ;

  Delete({
    @required this.where ,
    @required this.index,
    @required this.amount,
    @required this.title ,
    @required this.date,
    @required this.id ,
  });
}