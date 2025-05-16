import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vet_sotf_app/providers/productos/productos_provider.dart';

import '../../../config/global/palet_colors.dart';

class Category_card_widget extends StatelessWidget {
  Category_card_widget({
    super.key,
    required this.dataProductos,
    required this.size,
  });

  final ProductosProvider dataProductos;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final categorias = dataProductos.dropDownsProductos[0].grupo;

    return SizedBox(
      height: 50, // Establece la altura deseada del área de categorías
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final isSelected = dataProductos.selectedGrupoIndex == index;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: size.height * 0.04,
            width: size.width * 0.4,
            child: ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                    ColorPalet.complementViolet3.withAlpha(50)),
                backgroundColor: MaterialStateProperty.all(
                  isSelected
                      ? ColorPalet.complementViolet3
                      : ColorPalet.backGroundColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                        color: ColorPalet.complementViolet3, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                dataProductos.updateSubgrupos(index);
                dataProductos.updateSelectedGroupAndSubGroup(
                  dataProductos.grupos[index].grupoId,
                  null, // Reinicia el subGrupoId seleccionado al cambiar de grupo
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cat.nombreGrupo,
                    style: TextStyle(
                        color: isSelected
                            ? ColorPalet.backGroundColor
                            : ColorPalet.secondaryDefault,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Iconsax.edit_2,
                      color: isSelected
                          ? Colors.white
                          : ColorPalet.complementViolet3),
                ],
              ),
            ),
          ) /* Container(
            width: size.width * 0.45,
            margin: const EdgeInsets.only(right: 5.0),
            child: InkWell(
              onTap: () {},
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: ColorPalet.secondaryDefault,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: ColorPalet.backGroundColor,
                child: ListTile(
                  leading: Icon(
                    cardCategoryList[index].icon.icon,
                    color: ColorPalet.secondaryDefault,
                  ),
                  title: Text(
                    cardCategoryList[index].name,
                    style: const TextStyle(
                      color: ColorPalet.secondaryDefault,
                    ),
                  ),
                ),
              ),
            ),
          ) */
              ;
        },
      ),
    );
  }
}
