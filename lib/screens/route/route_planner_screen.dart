import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/theme.dart';
import '../../providers/route_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/route_option_card.dart';

class RoutePlannerScreen extends StatefulWidget {
  const RoutePlannerScreen({super.key});

  @override
  State<RoutePlannerScreen> createState() => _RoutePlannerScreenState();
}

class _RoutePlannerScreenState extends State<RoutePlannerScreen> {
  final _pickupController = TextEditingController(text: 'Colombo Fort');
  final _destController = TextEditingController();
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _pickupController.dispose();
    _destController.dispose();
    super.dispose();
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  void _searchRoutes() {
    final routeProvider = context.read<RouteProvider>();
    routeProvider.setPickupLocation(_pickupController.text);
    routeProvider.setDestination(_destController.text);
    routeProvider.searchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Route Planner',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CustomTextField(
                  controller: _pickupController,
                  hintText: 'Pickup location',
                  prefixIcon: Icons.my_location_rounded,
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _destController,
                  hintText: 'Where are you going?',
                  prefixIcon: Icons.location_on_rounded,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_destController.text.isEmpty) {
                        _destController.text = 'Bambalapitiya';
                      }
                      _searchRoutes();
                    },
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text('Find Routes'),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
          // Map + Routes
          Expanded(
            child: Consumer<RouteProvider>(
              builder: (context, routeProvider, _) {
                if (routeProvider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 16),
                        Text('Analyzing safety data...'),
                      ],
                    ),
                  );
                }

                if (routeProvider.routes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.route_rounded,
                            size: 80,
                            color: AppColors.textHint.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Enter destination to find safe routes',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Map
                    SizedBox(
                      height: 220,
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (routeProvider.routes.isNotEmpty) {
                            final firstRoute = routeProvider.routes.first;
                            if (firstRoute.points.isNotEmpty) {
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                  _boundsFromLatLngList(firstRoute.points),
                                  30.0,
                                ),
                              );
                            }
                          }
                        },
                        initialCameraPosition: CameraPosition(
                          target: routeProvider.routes.isNotEmpty && routeProvider.routes.first.points.isNotEmpty 
                              ? routeProvider.routes.first.points.first 
                              : const LatLng(6.9271, 79.8612),
                          zoom: 13.0,
                        ),
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        polylines: routeProvider.routes.map((route) {
                          final isSelected =
                              route.id == routeProvider.selectedRoute?.id;
                          return Polyline(
                            polylineId: PolylineId(route.id),
                            points: route.points,
                            color: isSelected
                                ? route.safetyLevel.color
                                : route.safetyLevel.color.withValues(alpha: 0.3),
                            width: isSelected ? 5 : 3,
                          );
                        }).toSet(),
                        markers: routeProvider.routes.isEmpty ? {} : {
                          Marker(
                            markerId: const MarkerId('pickup'),
                            position: routeProvider.routes.first.points.first,
                          ),
                          Marker(
                            markerId: const MarkerId('destination'),
                            position: routeProvider.routes.first.points.last,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                          ),
                        },
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    // Route Options
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: routeProvider.routes.length + 1,
                        itemBuilder: (context, index) {
                          if (index == routeProvider.routes.length) {
                            // Start Navigation Button
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Navigation started on ${routeProvider.selectedRoute?.safetyLevel.label ?? "route"}!',
                                          style: GoogleFonts.inter(),
                                        ),
                                        backgroundColor: AppColors.safe,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.navigation_rounded, size: 20),
                                  label: const Text('Start Navigation'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.safe,
                                  ),
                                ),
                              ),
                            );
                          }
                          final route = routeProvider.routes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: RouteOptionCard(
                              route: route,
                              isSelected:
                                  route.id == routeProvider.selectedRoute?.id,
                              onTap: () => routeProvider.selectRoute(route),
                            ),
                          ).animate().fadeIn(
                              delay: Duration(milliseconds: 300 + index * 100));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
