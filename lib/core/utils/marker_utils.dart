import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Map<String, BitmapDescriptor>> loadCustomMarkers() async {
  try {
    return {
      // Hotspot -> ROJO (Peligro o Mucha actividad)
      "hotspot": BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

      // Increasing -> VERDE (Subiendo / Bueno)
      "Increasing": BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),

      // Decreasing -> AZUL (Bajando / Frío)
      "Decreasing": BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),

      // Little -> NARANJA o AMARILLO (Poco / Precaución)
      // OJO: Asegúrate de que aquí diga "Little" o "little" igual que en tu Dropdown
      "Little": BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    };
  } catch (e) {
    print("Error loading markers: $e");
    return {};
  }
}
