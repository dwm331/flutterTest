import 'package:flutter/material.dart';
import '../../model/service.dart';

class ServiceInfoBox extends StatelessWidget {
  const ServiceInfoBox({
    super.key,
    required this.service,
    required this.spotListLength,
    required this.enabled,
  });
  final Service service;
  final int spotListLength;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = enabled ? () {} : null;
    return Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Row(children: [
              Text(service.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24.0)),
              const Spacer(),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text('$spotListLength 筆資料',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11.0))),
              const Spacer(),
              ElevatedButton(onPressed: onPressed, child: const Text('展開列表'))
            ])));
  }
}
