import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot/feature/user/home/service/hotspots_display_service.dart';

void showFilterDialog(
  BuildContext context,
  WidgetRef ref,
  AsyncValue<List<String>> fishCategoriesAsync,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Filter by Fish Type"),
        content: fishCategoriesAsync.when(
          data: (fishCategories) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("All"),
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                  ),
                  ...fishCategories.map(
                    (category) => ListTile(
                      title: Text(category),
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, _) => Text("Error loading fish categories: $error"),
          loading: () => CircularProgressIndicator(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      );
    },
  );
}
