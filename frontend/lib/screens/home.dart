
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/models/station.dart';
import 'package:frontend/services/station_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _citycontroller = TextEditingController();
  final Map<String, Marker> _markers = {};
  late GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  Future<void> _searchByCity() async {
    final googlestations = await getStations(_citycontroller.text);
    setState(() {
      _markers.clear();
      if (googlestations.data != null) {
        List<Station>? stations = googlestations.data as List<Station>?;
        for (final station in stations!) {
          final marker = Marker(
            markerId: MarkerId(station.id),
            position: LatLng(station.lat, station.lng),
            infoWindow: InfoWindow(
              title: 'Service ${station.service}',
              snippet: 'Price ${station.price}',
            ),
          );
          _markers[station.service] = marker;
        }
      } else {
        print('Error: ${googlestations.error}');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station service'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: (){
              logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: _citycontroller,
                  decoration: const InputDecoration(
                  labelText: "City...",
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _searchByCity,
                child: const Text('Search'),
              ),
              const SizedBox(height: 30),
                Container(
                  height: 600,
                  child: GoogleMap(
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition : const CameraPosition(target: LatLng(34, -5.7), zoom:7),
                  markers: _markers.values.toSet(),

                ),
                )
              ],
            ),
          )
          ),
      
      
    );
  }
}