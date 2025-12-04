import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Esta función ahora debe ser ASÍNCRONA (async) porque cargar imágenes toma unos milisegundos
Future<Map<String, BitmapDescriptor>> loadCustomMarkers() async {
  try {
    return {
      'Hotspots': await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish4.png", // Asegúrate que el nombre coincida EXACTO
      ),

      // 2. Cargar INCREASING (Verde)
      'Increasing': await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish3.png", // Asegúrate que el nombre coincida EXACTO
      ),

      // 3. Cargar DECREASING (Azul)
      'Decreasing': await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish1.png", // Asegúrate que el nombre coincida EXACTO
      ),

      // 4. Cargar LITTLE (Naranja)
      'Little': await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(48, 48)),
        "assets/marker/fish2.png", // Asegúrate que el nombre coincida EXACTO
      ),
    };
  } catch (e) {
    // Si algo falla (ej. nombre de archivo mal escrito), se imprime el error
    print("Error cargando iconos de marcadores: $e");
    return {};
    // Podrías cargar un marcador por defecto aquí como plan B si quisieras
  }
}
