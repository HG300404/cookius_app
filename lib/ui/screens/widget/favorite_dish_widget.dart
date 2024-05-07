import 'package:cookius_app/ui/screens/detail_dish_page.dart';
import 'package:flutter/material.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:flutter/cupertino.dart';

class FavoriteDishWidget extends StatelessWidget {
  const FavoriteDishWidget({
    Key? key,
    required this.index,
    required this.dishList,
  }) : super(key: key);

  final int index;
  final List<Dishes> dishList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Dishes dish = dishList[index];

    return GestureDetector(
      onTap: () {
        // Just navigating to DetailDish without passing any parameters
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const DetailDish(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Constants.primaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80.0,
        padding: const EdgeInsets.only(left: 10, top: 10),
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 80.0,
                    child: dish.imageURL.isNotEmpty
                        ? Image.network(dish.imageURL)
                        : Container(),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.type,
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                      Text(
                        dish.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Constants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                dish.calo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Constants.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}