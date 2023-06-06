// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

abstract class EditRule {
  ExecutionInstruction apply(Editor editor, DocumentComposer composer, TextEditingDelta delta);
}

class EditRules {
  const EditRules({
    required this.rules,
  });
  final List<EditRule> rules;

  ExecutionInstruction apply(Editor editor, DocumentComposer composer, TextEditingDelta delta) {
    for (final rule in rules) {
      final execution = rule.apply(editor, composer, delta);
      if (execution == ExecutionInstruction.blocked || execution == ExecutionInstruction.haltExecution) {
        return execution;
      }
    }
    return ExecutionInstruction.continueExecution;
  }
}
