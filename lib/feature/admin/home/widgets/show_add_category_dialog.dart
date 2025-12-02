// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/core/utils/utils.dart';
import 'package:hotspot/feature/admin/home/service/add_items_service.dart';

Future<void> showAddCategoryDialog(
  BuildContext context,
  WidgetRef ref,
  TextEditingController newCategoryController,
) async {
  final notifier = ref.read(additemProvider.notifier);
  final String? newCategory = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Add New Category"),
        content: TextField(
          controller: newCategoryController,
          decoration: InputDecoration(
            labelText: "Category Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              newCategoryController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final categoryName = newCategoryController.text.trim();
              if (categoryName.isEmpty) {
                mySnackBar(
                  message: "plase enter a category name",
                  context: context,
                );
                return;
              }
              try {
                await notifier.addCategory(categoryName);
                Navigator.pop(context, categoryName);
                mySnackBar(
                  message: "New Category added successfully",
                  context: context,
                );
              } catch (e) {
                mySnackBar(message: "$e", context: context);
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );

  if (newCategory != null && newCategory.isNotEmpty) {
    notifier.setSelectedCategory(newCategory);
    newCategoryController.text = newCategory;
  }
}
