enum CalSelectPlan {
  normal,
  lossWeightLV1,
  lossWeightLV2,
  gainWeightLV1,
  gainWeightLV2,
  gainWeightLV3,
}

extension CalSelectPlanExtension on CalSelectPlan {
  double get value {
    switch (this) {
      case CalSelectPlan.normal:
        return 1.0;
      case CalSelectPlan.lossWeightLV1:
        return 0.9;
      case CalSelectPlan.lossWeightLV2:
        return 0.79;
      case CalSelectPlan.gainWeightLV1:
        return 1.1;
      case CalSelectPlan.gainWeightLV2:
        return 1.21;
      case CalSelectPlan.gainWeightLV3:
        return 1.41;
      default:
        return 0;
    }
  }
}