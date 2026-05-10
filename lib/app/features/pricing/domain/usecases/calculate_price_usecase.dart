import 'package:bersih_in/app/features/booking/data/models/price_estimate_model.dart';
import 'package:bersih_in/app/features/pricing/data/repositories/pricing_repository_base.dart';

/// Domain use case that delegates to a [PricingRepositoryBase] implementation
/// to compute a price estimate from the booking parameters.
///
/// Callers depend only on this use case, not the concrete repository.
class CalculatePriceUseCase {
  final PricingRepositoryBase _repository;

  const CalculatePriceUseCase(this._repository);

  Future<PriceEstimateModel> call({
    required double roomSizeM2,
    required int dirtLevelIndex,
    required List<String> extras,
    required String dirtLevel,
  }) {
    return _repository.calculatePrice(
      roomSizeM2: roomSizeM2,
      dirtLevelIndex: dirtLevelIndex,
      extras: extras,
      dirtLevel: dirtLevel,
    );
  }
}
