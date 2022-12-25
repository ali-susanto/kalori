import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class NutritionData extends StatelessWidget {
  const NutritionData(
      {Key? key,
      required this.nutritionName,
      required this.nutritionValue,
      required this.valueColor,
      required this.dataColor})
      : super(key: key);
  final String nutritionValue;
  final String nutritionName;
  final Color valueColor;
  final Color dataColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var valueData = double.parse(nutritionValue) / 100 * 100;
    var value = double.parse(nutritionValue) / 100;
    return Column(
      children: [
        Container(
          width: size.width * 0.305,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LiquidLinearProgressIndicator(
            value: value,
            backgroundColor: valueColor.withOpacity(0.3),
            borderRadius: 20,
            valueColor: AlwaysStoppedAnimation(valueColor),
            direction: Axis.vertical,
            center: Text(
              "${valueData.toStringAsFixed(1)} %",
              style: TextStyle(
                color: dataColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          nutritionName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          "$nutritionValue g",
          style: const TextStyle(fontSize: 13),
        )
      ],
    );
  }
}
