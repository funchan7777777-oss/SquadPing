import 'package:flutter/widgets.dart';

double squadCompactTopPadding(BuildContext context, {double extra = 0}) {
  final safeTop = MediaQuery.paddingOf(context).top;
  final compactTop = safeTop > 12 ? safeTop - 12 : 0.0;
  return compactTop + extra;
}
