import 'package:flutter/material.dart';
import 'package:projectb/Addr.dart';
import 'package:projectb/AddressPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:projectb/urlConstant/AppConstants.dart';


class MapPage extends StatefulWidget {
  final String? addressId;
  const MapPage({Key? key, this.addressId}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Color customGreenColor = const Color(0xFF53b175);
  GoogleMapController? _mapController;
  static const LatLng _initialPosition = LatLng(13.06595551171911, 80.15521332965977);
  String? userMobileNumber ;
  TextEditingController _addressController = TextEditingController();
  Set<Marker> _markers = {};
  LatLng? _selectedLatLng;
  Map<String, dynamic>? addressData;
  @override


  void initState() {

    super.initState();
    _requestLocationPermission();
    _initializeUser();
  }


  Future<void> _initializeUser() async {
    String? userId = await AppConstants.getPhoneNumber();
    setState(() {
    userMobileNumber = userId;
    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else if (status.isDenied) {
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
      _addMarker(currentLatLng);
      _getAddressFromLatLng(currentLatLng);
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = '${placemark.street}, ${placemark.subLocality}, '
            '${placemark.locality}, '
            '${placemark.administrativeArea}, ${placemark.postalCode}';
        setState(() {
          _addressController.text = address;
        });
        print("_addressController.text: ${_addressController.text}");
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId('selected-location'),
        position: position,
      ));
      _selectedLatLng = position;
    });
    _getAddressFromLatLng(position);
    print("_selectedLatLng: ${_selectedLatLng?.latitude}, ${_selectedLatLng?.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 19),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Add Your Address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: userMobileNumber != null && userMobileNumber!.isNotEmpty?  Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 15,
              ),
              markers: _markers,
              onTap: (LatLng position) {
                _addMarker(position);
              },
              onLongPress: (LatLng position) {
                _addMarker(position);
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8.0),
                  const Text(
                    'Your Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Your Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          _addressController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    width: 300,
                    height: 52,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addr(
                              googleAddress: _addressController.text,
                              latLng: _selectedLatLng,
                              addressId: widget.addressId,
                            ), // Replace with the desired destination
                          ),
                        );
                      },
                      color: customGreenColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text("Confirm Address"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ):Center(child: CircularProgressIndicator(),),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 200),
        child: FloatingActionButton.extended(
          onPressed: _getCurrentLocation,
          label: const Text(
            'Locate Me',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.my_location,
            color: customGreenColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
