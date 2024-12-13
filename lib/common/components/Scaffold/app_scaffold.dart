import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/common/styles/component_style.dart';

import '../../../constants/index.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.children,
    this.isScrollable = true,
    this.canNavigateBack = false,
    this.shouldResize,
    this.fab,
  });

  final List<Widget> children;
  final bool isScrollable;
  final bool canNavigateBack;
  final bool? shouldResize;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    final scaffoldContent = Padding(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: shouldResize,
        backgroundColor: Colors.white,
        floatingActionButton: fab,
        appBar: canNavigateBack
            ? AppBar(
                surfaceTintColor: Colors.white,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: AppColors.black),
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: isScrollable
              ? SingleChildScrollView(child: scaffoldContent)
              : scaffoldContent,
        ),
      ),
    );
  }
}
