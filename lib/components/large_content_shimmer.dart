import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LargeContentShimmer extends StatelessWidget {
  const LargeContentShimmer({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.3,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.grey)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.2,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: size.width,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                width: size.width,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
