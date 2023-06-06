// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

abstract class EditRule {
  Editor get editor;
  DocumentComposer get composer;
  Document get document;

  ExecutionInstruction apply(TextEditingDelta delta);
}

class EditRules {
  const EditRules({
    required this.rules,
  });
  final List<EditRule> rules;

  ExecutionInstruction apply(TextEditingDelta delta) {
    for (final rule in rules) {
      final execution = rule.apply(delta);
      if (execution == ExecutionInstruction.blocked || execution == ExecutionInstruction.haltExecution) {
        return execution;
      }
    }
    return ExecutionInstruction.continueExecution;
  }
}
