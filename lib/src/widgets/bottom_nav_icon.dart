import 'package:flutter/material.dart';
import 'package:food_app/src/widgets/title.dart';

class BottomNavIcon extends StatelessWidget {
  final String image;
  final String name;
  final Function onTap;

  BottomNavIcon({this.image, this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap ?? null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/$image',
              height: 20,
              width: 20,
            ),
            SizedBox(
              height: 2,
            ),
            CustomText(
              text: '$name',
              size: 14,
            )
          ],
        ),
      ),
    );
  }
}
