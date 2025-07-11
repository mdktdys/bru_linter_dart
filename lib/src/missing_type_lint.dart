import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class MissingTypeLintCode extends DartLintRule {
  MissingTypeLintCode() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_type',
    problemMessage: 'Variable declaration is missing an explicit type.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclarationList((node) {
      if (node.type == null) {
        reporter.atNode(node, code);
      }
    });
  }
}
