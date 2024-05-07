import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/favoritesController.dart';
import 'package:cookius_app/models/favorite.dart';
import 'package:cookius_app/ui/screens/detail_dish_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/dishes.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dishes')
            .where('isFavorited', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var dishesDocuments = snapshot.data!.docs;
          if (dishesDocuments.isEmpty) {
            // Không có món ăn nào yêu thích
            return buildNoFavoritesView();
          }
          // Hiển thị danh sách món ăn yêu thích
          return ListView.builder(
            itemCount: dishesDocuments.length,
            itemBuilder: (context, index) {
              Dishes dish = Dishes.fromJson(dishesDocuments[index].data() as Map<String, dynamic>, dishesDocuments[index].id);
              return buildDishWidget(dish, context);
            },
          );
        },
      ),
    );
  }

  // Xây dựng Widget hiển thị khi không có món ăn yêu thích nào
  Widget buildNoFavoritesView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Image.asset('assets/images/favorited.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Your favorited Dishes',
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildDishWidget(Dishes dish, BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigating to DetailDish with the dish parameter passed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDish(),
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

  Future<void> toggleFavoriteStatus(Dishes dish, String userID) async {
    FavoritesController favoritesController = FavoritesController();
    dish.isFavorited = !dish.isFavorited;

    try {
      if (dish.isFavorited) {
        // Thêm vào danh sách yêu thích
        Favorite newFavorite = Favorite(
          dishID: dish.dishID,
          userID: userID, favoriteID: '',
        );
        await favoritesController.addFavorite(newFavorite);
        print('Added to favorites');
      } else {
        // Xóa khỏi danh sách yêu thích
        await favoritesController.deleteFavoriteByUserIdAndDishId(userID, dish.dishID);
        print('Removed from favorites');
      }
    } catch (e) {
      print("Error toggling favorite status: $e");
    }

    // Cập nhật UI nếu cần
    // setState(() {});
  }
}