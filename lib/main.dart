import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simulador_de_memoria/app.dart';

void main() {
  runApp(
    EasyDynamicThemeWidget(
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      child: ResponsiveSizer(
        builder: (buildContext, orientation, screenType) {
          return Simulador();
        },
      ),
    ),
  );
}
