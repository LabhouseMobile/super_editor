// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

abstract class EditorRule {
  ExecutionInstruction apply(
    DocumentEditor editor,
    DocumentComposer composer,
    TextEditingDelta delta,
  );
}

class EditorRules {
  const EditorRules({
    this.rules = const [],
  });
  final List<EditorRule> rules;

  ExecutionInstruction apply(DocumentEditor editor, DocumentComposer composer, TextEditingDelta delta) {
    for (final rule in rules) {
      final execution = rule.apply(editor, composer, delta);
      if (execution == ExecutionInstruction.blocked || execution == ExecutionInstruction.haltExecution) {
        return execution;
      }
    }

    return ExecutionInstruction.continueExecution;
  }
}
