import 'package:flutter/material.dart';
import 'package:food_app/src/commons.dart';
import 'package:food_app/src/models/order.dart';
import 'package:food_app/src/providers/app.dart';
import 'package:food_app/src/providers/user.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: 'Pedidos'),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
        itemCount: authProvider.orders.length,
        itemBuilder: (context,index){
          OrderModel _order = authProvider.orders[index];
          return ListTile(
            leading: CustomText(text: '\$${_order.total / 100}', weight: FontWeight.bold,),
            title: Text(_order.description),
            subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
            trailing: CustomText(text: _order.status, color: green,),
          );
        }),
    );
  }
}