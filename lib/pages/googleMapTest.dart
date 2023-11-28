import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello/view/spot/spotInfoBox.dart';

import '../model/spot.dart';
import '../model/service.dart';

const initialPosition = LatLng(25.03849162, 121.5645213);
const _pinkHue = 350.0;

class GoogleMapPageRoute extends StatelessWidget {
  const GoogleMapPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GoogleMapPage(title: 'GoogleMapPage'),
    );
  }
}

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;
  final bool enabled = true;

  @override
  Widget build(BuildContext context) {
    final List<Service> serviceList = [Service(1, '防空避難設備', '')];
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green[700],
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(serviceList[0].name),
            elevation: 2,
          ),
          body: Stack(
              alignment: Alignment.center,
              children: [SpotMap(service: serviceList[0])]),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SpotMap extends StatefulWidget {
  const SpotMap({
    super.key,
    required this.service,
  });
  final Service service;
  @override
  State<SpotMap> createState() => _SpotMapState();
}

class _SpotMapState extends State<SpotMap> {
  late GoogleMapController mapController;
  final List<Spot> spotList = [
    Spot('6904450270815801344', '臺北市政府市政大樓', '臺北市信義區松高路1號', 25.039553,
        121.56396),
    Spot('6904450270065020928', '三連大樓', '臺北市信義區忠孝東路四段560號', 25.040983,
        121.56389),
    Spot('6904450270895493120', '商業大樓', '臺北市信義區忠孝東路五段68號', 25.040648,
        121.566696),
    Spot('6904450269242937344', '新光三越', '臺北市信義區松壽路11號', 25.036072, 121.56728),
    Spot('6904450267263225856', '內政部警政署刑事警察局', '臺北市信義區忠孝東路四段553巷5號', 25.042425,
        121.562485),
    Spot('6904450269708505088', '臺北世貿大樓', '臺北市信義區基隆路一段333號', 25.034254,
        121.56111),
    Spot('6904450266747326464', '信義分局"', '臺北市信義區信義路五段17號"', 25.033169, 121.5677)
  ];
  Spot? selectedSpot;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: initialPosition,
          zoom: 16.0,
        ),
        markers: spotList
            .map((spotItem) => Marker(
                markerId: MarkerId(spotItem.placeId),
                icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                position: LatLng(spotItem.latitude, spotItem.longitude),
                infoWindow:
                    InfoWindow(title: spotItem.name, snippet: spotItem.address),
                onTap: () {
                  setState(() {
                    selectedSpot = spotItem;
                  });
                }))
            .toSet(),
        onMapCreated: _onMapCreated,
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
            visible: (selectedSpot?.placeId ?? '').isNotEmpty,
            child: Container(
              height: 114,
              margin: const EdgeInsets.only(bottom: 88, left: 16, right: 16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child:
                  SpotInfoBox(spot: selectedSpot ?? Spot('', '', '', 0.0, 0.0)),
            )),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: ServiceInfoBox(
            service: widget.service,
            spotListLength: spotList.length,
            enabled: true,
          )),
    ]);
  }
}

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
