import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bersih_in/app/features/booking/data/models/order_model.dart';

class OrderHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of orders for a specific user, ordered by createdAt descending
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  /// Get a single order by ID
  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw Exception('Order tidak ditemukan');
    }
    return OrderModel.fromFirestore(doc);
  }
}
