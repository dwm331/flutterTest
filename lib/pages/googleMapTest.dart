import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello/view/service/serviceInfoBox.dart';
import 'package:hello/view/spot/spotInfoBox.dart';

import '../model/spot.dart';
import '../model/service.dart';
import '../controller/dio/dioClient.dart';

const initialPosition = LatLng(22.620715972444586, 120.28106318474515);
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
    final List<Service> serviceList = [Service(1, '高雄旅遊網-景點資料', '')];
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
  final DioClient _client = DioClient();
  late GoogleMapController mapController;
  late Future<List<Spot>> spotList;
  Spot? selectedSpot;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    spotList = _client.fetchSpots();
    return FutureBuilder<List<Spot>>(
      future: spotList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          // return Text('${snapshot.data!.length}');
          return Stack(alignment: Alignment.center, children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: initialPosition,
                zoom: 16.0,
              ),
              markers: snapshot.data!
                  .map((spotItem) => Marker(
                      markerId: MarkerId(spotItem.placeId),
                      icon: BitmapDescriptor.defaultMarkerWithHue(_pinkHue),
                      position: LatLng(spotItem.latitude, spotItem.longitude),
                      infoWindow: InfoWindow(
                          title: spotItem.name,
                          snippet:
                              '<div><p>${spotItem.description}</p><img hidden src="${spotItem.picture1}" /></div>'),
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
                  visible: selectedSpot != null,
                  child: Container(
                      height: 120,
                      margin: const EdgeInsets.only(
                          bottom: 88, left: 16, right: 16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: SpotInfoBox(
                          spot: selectedSpot ??
                              const Spot(
                                  placeId: '',
                                  name: '',
                                  address: '',
                                  latitude: 0,
                                  longitude: 0,
                                  description: '',
                                  opentime: '',
                                  picture1: ''))),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: ServiceInfoBox(
                  service: widget.service,
                  spotListLength: snapshot.data!.length,
                  enabled: true,
                )),
          ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
