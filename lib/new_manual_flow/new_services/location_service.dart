import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime capturedAt;
  final String? error;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.capturedAt,
    this.error,
  });

  bool get hasLocation => latitude != 0 || longitude != 0;
  String get coordString =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
}

class LocationService {
  // Live location — refreshed on every capture, NOT cached from login
  static Future<LocationResult> getCurrentLocation() async {
    final now = DateTime.now();

    if (kIsWeb) return await _getWebLocation(now);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult(
          latitude: 0, longitude: 0,
          address: 'Location services disabled — enable GPS',
          capturedAt: now, error: 'Location services disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult(
            latitude: 0, longitude: 0,
            address: 'Location permission denied',
            capturedAt: now, error: 'Permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationResult(
          latitude: 0, longitude: 0,
          address: 'Location permission permanently denied — enable in Settings',
          capturedAt: now, error: 'Permission permanently denied');
    }

    try {
      Position pos;
      try {
        pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
            .timeout(const Duration(seconds: 15));
      } catch (_) {
        pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low)
            .timeout(const Duration(seconds: 10));
      }

      String address =
          '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
      try {
        final marks = await placemarkFromCoordinates(
            pos.latitude, pos.longitude)
            .timeout(const Duration(seconds: 5));
        if (marks.isNotEmpty) {
          final p = marks.first;
          final parts = <String>[
            if ((p.subLocality ?? '').isNotEmpty)      p.subLocality!,
            if ((p.locality ?? '').isNotEmpty)         p.locality!,
            if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea!,
            if ((p.country ?? '').isNotEmpty)          p.country!,
          ];
          if (parts.isNotEmpty) address = parts.join(', ');
        }
      } catch (_) {}

      return LocationResult(
          latitude: pos.latitude, longitude: pos.longitude,
          address: address, capturedAt: DateTime.now());
    } catch (e) {
      debugPrint('[Location] Error: $e');
      return LocationResult(
          latitude: 0, longitude: 0,
          address: 'Unable to get location',
          capturedAt: now, error: e.toString());
    }
  }

  static Future<LocationResult> _getWebLocation(DateTime now) async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return LocationResult(latitude: 0, longitude: 0,
            address: 'Permission denied', capturedAt: now);
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium)
          .timeout(const Duration(seconds: 15));
      return LocationResult(
          latitude: pos.latitude, longitude: pos.longitude,
          address: '${pos.latitude.toStringAsFixed(5)}, '
              '${pos.longitude.toStringAsFixed(5)}',
          capturedAt: DateTime.now());
    } catch (e) {
      return LocationResult(latitude: 0, longitude: 0,
          address: 'Unable to get location', capturedAt: now,
          error: e.toString());
    }
  }
}
