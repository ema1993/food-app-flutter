import 'package:flutter/material.dart';
import 'package:food_app/src/commons.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/providers/product.dart';
import 'package:food_app/src/screens/detail.dart';
import 'package:food_app/src/widgets/product.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:provider/provider.dart';

class ProductSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        title: CustomText(
          text: 'Platos',
          size: 20,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {})
        ],
      ),
      body: productProvider.productsSearched.length < 1
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: grey,
                    size: 30,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomText(
                    text: 'No se encontraron platos',
                    color: grey,
                    weight: FontWeight.w300,
                    size: 22,
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: productProvider.productsSearched.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async{
                    changeScreen(context, Detail(product: productProvider.productsSearched[index]),);
                  },
                                  child: ProductWidget(
                    product: productProvider.productsSearched[index],
                  ),
                );
              }),
    );
  }
}
