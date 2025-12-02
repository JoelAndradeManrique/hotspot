import 'package:flutter/material.dart';
import 'package:hotspot/feature/admin/home/service/display_item_service.dart';
import 'package:hotspot/feature/admin/home/widgets/update_dialog_box.dart';

Future<void> showEditConfirmationDialog(
  BuildContext
  parentContext, // 1. Le cambié el nombre para identificarlo mejor (Contexto VIVO)
  String hotspotsId,
  String currentCondition,
) async {
  return showDialog(
    context: parentContext,
    builder: (dialogContext) {
      // 2. Le puse nombre diferente (Contexto del DIÁLOGO)
      return AlertDialog(
        title: const Text("Manage Hotspot"),
        content: const Text(
          "Choose you want to delete or edit the hotspots or cancel the dialog",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            // Usamos dialogContext para cerrar EL DIÁLOGO
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // 3. Cerramos el diálogo usando SU contexto
              Navigator.pop(dialogContext);

              // 4. Ejecutamos la acción usando el contexto PADRE (que sigue vivo)
              await deleteHotspot(parentContext, hotspotsId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Cerramos diálogo

              // Usamos contexto PADRE para abrir el siguiente diálogo
              await showUpdateConditionDialog(
                parentContext,
                hotspotsId,
                currentCondition,
              );
            },
            child: const Text("Edit", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}
