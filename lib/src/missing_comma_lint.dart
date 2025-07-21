import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class MissingCommaLint extends DartLintRule {
  MissingCommaLint() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_comma',
    problemMessage: 'запятую поставь, сука!',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final lineInfo = resolver.lineInfo;

    context.registry.addArgumentList((ArgumentList node) {
      final elements = node.arguments;
      if (elements.isEmpty) return;

      final lastArg = elements.last;
      final Expression lastExpr = lastArg is NamedExpression
          ? lastArg.expression
          : lastArg;

      // Пропускаем, если последний аргумент:
      // - map/set-литерал,
      // - лямбда (FunctionExpression),
      // - вызов метода (MethodInvocation),
      // - вызов функционального литерала (FunctionExpressionInvocation),
      // - создание экземпляра (InstanceCreationExpression),
      // - или если в списке есть map/set-литерал и сам аргумент — NamedExpression
      if (
        lastExpr is SetOrMapLiteral ||
        lastExpr is FunctionExpression ||
        lastExpr is MethodInvocation ||
        lastExpr is FunctionExpressionInvocation ||
        lastExpr is InstanceCreationExpression ||
        (elements.any((e) => e is SetOrMapLiteral) && lastArg is NamedExpression)
      ) {
        return;
      }

      _checkTrailingComma(
        elements: elements,
        closingToken: node.rightParenthesis,
        lineInfo: lineInfo,
        reporter: reporter,
        code: code,
      );
    });

    context.registry.addListLiteral((ListLiteral node) {
      _checkTrailingComma(
        elements: node.elements,
        closingToken: node.rightBracket,
        lineInfo: lineInfo,
        reporter: reporter,
        code: code,
      );
    });
  }
}

void _checkTrailingComma({
  required NodeList<AstNode> elements,
  required Token closingToken,
  required LineInfo lineInfo,
  required ErrorReporter reporter,
  required LintCode code,
}) {
  if (elements.isEmpty) return;

  final firstLine = lineInfo.getLocation(elements.first.offset).lineNumber;
  final lastLine = lineInfo.getLocation(elements.last.end).lineNumber;
  if (firstLine == lastLine) return;

  final prev = closingToken.previous!;
  if (prev.lexeme != ',') {
    reporter.atToken(prev, code);
  }
}
