import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmallContentShimmer extends StatelessWidget {
  const SmallContentShimmer({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: size.height * 0.1,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2, color: Colors.grey)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: size.width * 0.3,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.55,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 0.55,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}