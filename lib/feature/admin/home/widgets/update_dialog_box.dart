import 'package:flutter/material.dart';
import 'package:hotspot/feature/admin/home/model/add_items_model.dart';
import 'package:hotspot/feature/admin/home/service/display_item_service.dart';

Future<void> showUpdateConditionDialog(
  BuildContext context,
  String hotspotsId,
  String currentCondition,
) async {
  String? selectedCondition = currentCondition;
  final conditions = AddItemsState().conditions;
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Condition"),
            content: Column(
              children: [
                DropdownButton<String>(
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
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),

              TextButton(
                onPressed: () async {
                  if (selectedCondition != null &&
                      selectedCondition != currentCondition) {
                    await updateHotspotsConditions(
                      context,
                      hotspotsId,
                      selectedCondition!,
                    );
                  }
                },
                child: Text("Save", style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    },
  );
}
