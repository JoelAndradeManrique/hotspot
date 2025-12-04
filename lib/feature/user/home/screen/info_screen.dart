import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/user/home/service/info_service.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  // --- FUNCIÓN MÁGICA: De texto (Firebase) a Imagen (Assets) ---
  String _getLocalImagePath(String key) {
    switch (key.toLowerCase()) {
      case 'hotspot':
        return 'assets/marker/fish4.png';
      case 'increasing':
        return 'assets/marker/fish3.png';
      case 'decreasing':
        return 'assets/marker/fish1.png';
      case 'little':
        return 'assets/marker/fish2.png';
      default:
        return 'assets/marker/fish4.png'; // Imagen por defecto
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Escuchamos al provider que trae los datos de Firebase (título y descripción)
    final appInfoAsync = ref.watch(appInfoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("App Info and Symbols"),
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
      ),
      body: appInfoAsync.when(
        data: (infoList) {
          if (infoList.isEmpty) {
            return const Center(child: Text("App info coming soon"));
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10), // Un poco de margen se ve mejor
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              final appInfo = infoList[index];

              // 2. Convertimos la clave (ej. "hotspot") en ruta de imagen
              final imagePath = _getLocalImagePath(appInfo.image);

              return Card(
                // Usamos Card para que se vea más bonito
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    appInfo.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(appInfo.description),
                  // 3. Mostramos la imagen LOCAL
                  leading: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                    // Si el nombre está mal escrito en Firebase, mostramos un error en vez de tronar
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
        error: (error, _) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
