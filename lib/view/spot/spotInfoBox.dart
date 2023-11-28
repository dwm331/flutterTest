import 'package:flutter/material.dart';
import '../../model/spot.dart';

class SpotInfoBox extends StatelessWidget {
  const SpotInfoBox({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spot.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                  textAlign: TextAlign.left,
                ),
                Text(spot.address,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.0),
                    textAlign: TextAlign.left),
                Text('${spot.distance.toString()} km',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.0),
                    textAlign: TextAlign.left)
              ],
            )
          ],
        ));
  }
}
