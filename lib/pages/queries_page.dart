import 'package:covertosa_2/utils/queries_menu_items.dart';
import 'package:flutter/material.dart';

class QueriesPage extends StatelessWidget {
  const QueriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 20,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: QueriesMenuItems.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(QueriesMenuItems.items[index].icon),
                  title: Text(QueriesMenuItems.items[index].title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      QueriesMenuItems.items[index].routeName,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
