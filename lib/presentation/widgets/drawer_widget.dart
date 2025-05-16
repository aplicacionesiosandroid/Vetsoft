import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/providers/ui_provider.dart';

import 'my_drawer_header_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //final drawerProvider = Provider.of<DrawerProvider>(context);
    final uiProviderDrawer = Provider.of<UiProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(
                  context,
                  uiProviderDrawer.selectedOptionDrawer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container MyDrawerList(context, drawerProvider) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(context, "Home", Iconsax.home_1,
              drawerProvider == "Home" ? true : false, '/homeScreen'),
          menuItem(context, "Clinica", Iconsax.hospital,
              drawerProvider == "Clinica" ? true : false, '/homeScreen'),
          menuItem(context, "Peluqueria", Iconsax.pet,
              drawerProvider == "Peluqueria" ? true : false, '/homeScreen'),
          menuItem(context, "Petshop", Iconsax.shopping_bag,
              drawerProvider == "Petshop" ? true : false, '/homeScreen'),
          //menuItem(context, "Horario", Iconsax.clock,
          //     drawerProvider == "Horario" ? true : false, '/homeScreen'),
          menuItem(context, "Tareas", Iconsax.task_square4,
              drawerProvider == "Tareas" ? true : false, '/homeScreen'),
          menuItem(context, "Productos", Iconsax.box4,
              drawerProvider == "Productos" ? true : false, '/homeScreen'),
          menuItem(context, "Campañas", Iconsax.volume_high,
              drawerProvider == "Campañas" ? true : false, '/homeScreen'),
        ],
      ),
    );
  }

  Widget menuItem(
      context, String title, IconData icon, bool selected, String screen) {
    final uiProviderDrawer = Provider.of<UiProvider>(context);
    return Material(
      textStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: selected ? Color.fromARGB(255, 99, 92, 255) : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, screen);
          uiProviderDrawer.setSelectedIndexBottomBar(0);

          uiProviderDrawer.setOptionSelectedDrawer(title);
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? Colors.white
                      : Color.fromARGB(255, 72, 86, 109),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'inter',
                      color: selected
                          ? Colors.white
                          : Color.fromARGB(255, 72, 86, 109),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
