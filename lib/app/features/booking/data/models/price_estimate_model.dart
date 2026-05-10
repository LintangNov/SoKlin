import 'package:equatable/equatable.dart';

class PriceEstimateModel extends Equatable {
  final double roomSizeM2;
  final String dirtLevel;
  final int dirtLevelIndex;
  final List<String> extras;
  final double estimatedPrice;
  final int estimatedMinutes;

  const PriceEstimateModel({
    required this.roomSizeM2,
    required this.dirtLevel,
    required this.dirtLevelIndex,
    required this.extras,
    required this.estimatedPrice,
    required this.estimatedMinutes,
  });

  @override
  List<Object?> get props => [
        roomSizeM2,
        dirtLevel,
        dirtLevelIndex,
        extras,
        estimatedPrice,
        estimatedMinutes,
      ];
}
