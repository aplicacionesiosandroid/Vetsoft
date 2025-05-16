import 'package:flutter/material.dart';

class TabControllerModel extends ChangeNotifier {
  late TabController tabController;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
