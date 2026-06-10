import 'dart:typed_data';

enum VehiclePhotoAngle {
  front, rear, leftSide, rightSide, engine, dashboard, chassis, odometer,
}

String vehiclePhotoLabel(VehiclePhotoAngle angle) {
  switch (angle) {
    case VehiclePhotoAngle.front:     return 'Front View';
    case VehiclePhotoAngle.rear:      return 'Rear View';
    case VehiclePhotoAngle.leftSide:  return 'Left Side';
    case VehiclePhotoAngle.rightSide: return 'Right Side';
    case VehiclePhotoAngle.engine:    return 'Engine Bay';
    case VehiclePhotoAngle.dashboard: return 'Dashboard';
    case VehiclePhotoAngle.chassis:   return 'Chassis / Underside';
    case VehiclePhotoAngle.odometer:  return 'Odometer / Instrument';
  }
}

String vehiclePhotoInstruction(VehiclePhotoAngle angle) {
  switch (angle) {
    case VehiclePhotoAngle.front:
      return 'Capture the full front including headlamps, grille and number plate';
    case VehiclePhotoAngle.rear:
      return 'Capture the full rear including tail lights and number plate';
    case VehiclePhotoAngle.leftSide:
      return 'Full left profile — tyres, body panels and windows';
    case VehiclePhotoAngle.rightSide:
      return 'Full right profile — tyres, body panels and windows';
    case VehiclePhotoAngle.engine:
      return 'Open bonnet and capture the engine bay, battery and fluids';
    case VehiclePhotoAngle.dashboard:
      return 'Capture full dashboard with all warning lights visible';
    case VehiclePhotoAngle.chassis:
      return 'Capture underside / chassis number plate area';
    case VehiclePhotoAngle.odometer:
      return 'Capture odometer reading and speedometer clearly';
  }
}

String vehiclePhotoEmoji(VehiclePhotoAngle angle) {
  switch (angle) {
    case VehiclePhotoAngle.front:     return '🚗';
    case VehiclePhotoAngle.rear:      return '🔙';
    case VehiclePhotoAngle.leftSide:  return '◀';
    case VehiclePhotoAngle.rightSide: return '▶';
    case VehiclePhotoAngle.engine:    return '⚙';
    case VehiclePhotoAngle.dashboard: return '🎛';
    case VehiclePhotoAngle.chassis:   return '🔩';
    case VehiclePhotoAngle.odometer:  return '🔢';
  }
}

class VehiclePhoto {
  final VehiclePhotoAngle angle;
  final String path;
  final Uint8List? bytes;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime capturedAt;
  final bool savedToServer;
  final String? storageNote;

  VehiclePhoto({
    required this.angle,
    required this.path,
    this.bytes,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.capturedAt,
    this.savedToServer = false,
    this.storageNote,
  });

  String get coordString =>
      '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';

  String get formattedDate {
    final d = capturedAt;
    return '${d.day.toString().padLeft(2,'0')}-'
        '${d.month.toString().padLeft(2,'0')}-'
        '${d.year}  '
        '${d.hour.toString().padLeft(2,'0')}:'
        '${d.minute.toString().padLeft(2,'0')}:'
        '${d.second.toString().padLeft(2,'0')}';
  }
}
