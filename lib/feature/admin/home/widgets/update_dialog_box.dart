import 'package:flutter/material.dart';
import 'package:hotspot/feature/admin/home/model/add_items_model.dart';
import 'package:hotspot/feature/admin/home/service/display_item_service.dart';

Future<void> showUpdateConditionDialog(
  BuildContext parentContext, // 1. CAMBIO DE NOMBRE (Contexto vivo)
  String hotspotsId,
  String currentCondition,
) async {
  String? selectedCondition = currentCondition;
  final conditions = AddItemsState().conditions;

  await showDialog(
    context: parentContext, // Usamos el contexto padre para lanzar el diálogo
    builder: (dialogContext) {
      // 2. CAMBIO DE NOMBRE (Contexto temporal)
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Condition"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedCondition,
                  hint: const Text("Select Condition"),
                  isExpanded: true,
                  items: conditions.map((String condition) {
                    return DropdownMenuItem<String>(
                      value: condition,
                      child: Text(condition),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCondition = newValue;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                // Cerrar usando el contexto del diálogo
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  if (selectedCondition != null &&
                      selectedCondition != currentCondition) {
                    // 3. ACTUALIZAR usando PARENT CONTEXT (El seguro)
                    await updateHotspotsConditions(
                      parentContext, // <--- CLAVE: Usa parentContext aquí
                      hotspotsId,
                      selectedCondition!,
                    );
                    // 4. VERIFICAR si sigue vivo antes de cerrar
                    if (!dialogContext.mounted) return;
                  }
                },
                child: const Text("Save", style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    },
  );
}
