import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/models/favorite.dart';

class FavoritesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _favoritesRef;

  FavoritesController() {
    _favoritesRef = _firestore.collection('favorites');
  }

  Stream<QuerySnapshot> getAllFavorites() {
    return _favoritesRef.snapshots();
  }

  Future<DocumentSnapshot> getFavoriteById(String id) {
    return _favoritesRef.doc(id).get();
  }

  Future<void> addFavorite(Favorite favorite) async {
    await _favoritesRef.add(favorite.toJson());
  }

  Future<bool> updateFavorite(Favorite favorite, String id) async {
    try {
      await _favoritesRef.doc(id).update(favorite.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFavoriteById(String favoriteId) async {
    try {
      await _favoritesRef.doc(favoriteId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteFavoriteByUserIdAndDishId(String userId, String dishId) async {
    try {
      // Thực hiện truy vấn để tìm các document có userID và dishID phù hợp
      QuerySnapshot query = await _favoritesRef
          .where('userID', isEqualTo: userId)
          .where('dishID', isEqualTo: dishId)
          .get();

      // Lặp qua tất cả các document tìm được và xóa chúng
      for (var doc in query.docs) {
        await doc.reference.delete();
      }
      // Xử lý nếu thành công
      print("Favorite deleted successfully.");
    } catch (e) {
      // Xử lý lỗi
      print("Error deleting favorite: $e");
    }
  }

}