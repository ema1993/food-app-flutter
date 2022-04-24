import 'package:flutter/material.dart';
import 'package:food_app/src/helpers/screen_navigation.dart';
import 'package:food_app/src/models/products.dart';
import 'package:food_app/src/screens/detail.dart';
import 'package:food_app/src/widgets/loading.dart';
import 'package:food_app/src/widgets/title.dart';
import 'package:transparent_image/transparent_image.dart';

import '../commons.dart';

class FeaturedWidget extends StatelessWidget {
  final ProductModel product;

  const FeaturedWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 14, 16, 12),
      child: GestureDetector(
        onTap: () {
          changeScreen(
              context,
              Detail(
                product: product,
              ));
        },
        child: Container(
          height: 220,
          width: 200,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-2, -1),
                    blurRadius: 5)
              ]),
          child: Column(
            children: [
              Container(
                height: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Loading(),
                          ),
                        ),
                        Center(
                          child: FadeInImage.memoryNetwork(
                              fit: BoxFit.fill,
                              height: double.infinity,
                              placeholder: kTransparentImage,
                              image: product.image),
                        )
                      ],
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(text: product.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                offset: Offset(1, 1),
                                blurRadius: 4)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.favorite_border,
                          color: red,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: CustomText(
                          text: product.rating.toString(),
                          color: grey,
                          size: 14,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        Icons.star,
                        color: red,
                        size: 16,
                      ),
                      Icon(
                        Icons.star,
                        color: red,
                        size: 16,
                      ),
                      Icon(
                        Icons.star,
                        color: red,
                        size: 16,
                      ),
                      Icon(
                        Icons.star,
                        color: red,
                        size: 16,
                      ),
                      Icon(
                        Icons.star,
                        color: grey,
                        size: 16,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CustomText(
                      text: '\$${product.price / 100}',
                      weight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
