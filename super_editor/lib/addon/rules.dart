// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

abstract class EditRule {
  DocumentComposer get composer;
  Document get document;

  ExecutionInstruction apply(
    Editor editor,
    TextEditingDelta delta,
  );
}

class EditorRules {
  const EditorRules({
    this.rules = const [],
  });
  final List<EditRule> rules;

  ExecutionInstruction apply(Editor editor, TextEditingDelta delta) {
    for (final rule in rules) {
      final execution = rule.apply(editor, delta);
      if (execution == ExecutionInstruction.blocked || execution == ExecutionInstruction.haltExecution) {
        return execution;
      }
    }

    return ExecutionInstruction.continueExecution;
  }
}
