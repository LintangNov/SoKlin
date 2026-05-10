import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String orderId;
  final String userId;
  final double roomSizeM2;
  final String dirtLevel;
  final int dirtLevelIndex;
  final List<String> extras;
  final double estimatedPrice;
  final int estimatedMinutes;
  final String status;
  final String partnerName;
  final bool partnerVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.orderId,
    required this.userId,
    required this.roomSizeM2,
    required this.dirtLevel,
    required this.dirtLevelIndex,
    required this.extras,
    required this.estimatedPrice,
    required this.estimatedMinutes,
    required this.status,
    required this.partnerName,
    required this.partnerVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      userId: data['userId'] ?? '',
      roomSizeM2: (data['roomSizeM2'] ?? 0).toDouble(),
      dirtLevel: data['dirtLevel'] ?? '',
      dirtLevelIndex: data['dirtLevelIndex'] ?? 0,
      extras: List<String>.from(data['extras'] ?? []),
      estimatedPrice: (data['estimatedPrice'] ?? 0).toDouble(),
      estimatedMinutes: data['estimatedMinutes'] ?? 0,
      status: data['status'] ?? 'pending',
      partnerName: data['partnerName'] ?? '',
      partnerVerified: data['partnerVerified'] ?? false,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomSizeM2': roomSizeM2,
      'dirtLevel': dirtLevel,
      'dirtLevelIndex': dirtLevelIndex,
      'extras': extras,
      'estimatedPrice': estimatedPrice,
      'estimatedMinutes': estimatedMinutes,
      'status': status,
      'partnerName': partnerName,
      'partnerVerified': partnerVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  @override
  List<Object?> get props => [
        orderId,
        userId,
        roomSizeM2,
        dirtLevel,
        dirtLevelIndex,
        extras,
        estimatedPrice,
        estimatedMinutes,
        status,
        partnerName,
        partnerVerified,
        createdAt,
        updatedAt,
      ];
}
