  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:cookius_app/controller/dishesController.dart';
import 'package:cookius_app/ui/screens/detail_dish_page.dart';
import 'package:cookius_app/ui/screens/favorite_page.dart';
  import 'package:cookius_app/ui/screens/signin_page.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:page_transition/page_transition.dart';
  import '../../constants.dart';
  import '../../models/dishes.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {


    dishesController _dishesController = dishesController();



    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;

      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 20.0),
                width: size.width * .9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black54.withOpacity(.6),
                    ),
                    const Expanded(
                        child: TextField(
                          showCursor: false,
                          decoration: InputDecoration(
                            hintText: 'Search Món Ăn',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        )),
                    Icon(
                      Icons.mic,
                      color: Colors.black54.withOpacity(.6),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Constants.primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, bottom: 20),
                child: const Text(
                  'Món ăn Châu Á',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Color(0xff296e48),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .3,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _dishesController.getDishesByType('Châu Á'),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Lỗi: ${snapshot.error}');
                    }

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Dishes dish = Dishes.fromJson(document.data() as Map<String, dynamic>, document.id);
                            return buildDishCard(dish);
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    Widget buildDishCard(Dishes dish) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FavoritePage(),
            ),
          );
        },
        child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                dish.imageURL,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Calories: ${dish.calo}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time: ${dish.time}',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            dish.isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: Constants.primaryColor,
                          ),
                          onPressed: () {
                            // Toggle favorite status
                            _dishesController.toggleFavoriteStatus(dish.dishID, dish.isFavorited);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      );
    }
  }

