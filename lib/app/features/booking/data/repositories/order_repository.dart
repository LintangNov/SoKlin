import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bersih_in/app/features/booking/data/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new order in Firestore
  Future<String> createOrder(OrderModel order) async {
    final docRef = await _firestore.collection('orders').add(order.toMap());
    return docRef.id;
  }

  /// Get a single order by ID
  Future<OrderModel> getOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw Exception('Order tidak ditemukan');
    }
    return OrderModel.fromFirestore(doc);
  }

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
}
