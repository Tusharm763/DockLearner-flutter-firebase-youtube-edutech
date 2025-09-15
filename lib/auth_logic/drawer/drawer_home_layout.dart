import 'package:dock_learner/auth_logic/drawer/drawer_children.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../core/theme_set/theme_colors.dart';

class PreDefinedDrawer extends StatelessWidget {
  const PreDefinedDrawer({super.key, required this.childWidget, required this.adc});

  final Widget childWidget;
  final AdvancedDrawerController adc;

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      openRatio: 0.725,
      openScale: 0.775,
      controller: adc,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: true,
      disabledGestures: false,
      drawer: const DrawerChildrenWidget(),
      backdrop: Container(
        color: AppTheme.primary,
        child: const SafeArea(child: BackGroundWithGradientEffect()),
      ),
      childDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: childWidget,
    );
  }
}
