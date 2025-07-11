import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:bru_linter_dart/src/missing_type_lint.dart';

PluginBase createPlugin() => _BruLinter();

class _BruLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    MissingTypeLintCode(),
  ];
}
