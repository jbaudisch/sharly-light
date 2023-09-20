import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharly_app_light/services/api/api_helper.dart';

class ModelParent extends StatelessWidget {
  const ModelParent({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: APIHelper())
      ],
      child: child,
    );
  }
}
