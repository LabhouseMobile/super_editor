// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

abstract class EditRule {
  DocumentComposer get composer;
  Document get document;

  ExecutionInstruction apply(Editor editor);
  bool trigger(TextEditingDelta? delta, RawKeyEvent? rawKeyEvent);
}

class EditRules {
  const EditRules({required this.rules});
  final List<EditRule> rules;

  ExecutionInstruction apply(Editor editor, TextEditingDelta? delta, RawKeyEvent? rawKeyEvent) {
    for (final rule in rules) {
      final hasToExecute = rule.trigger(delta, rawKeyEvent);
      if (hasToExecute) {
        final execution = rule.apply(editor);
        if (execution == ExecutionInstruction.blocked || execution == ExecutionInstruction.haltExecution) {
          return execution;
        }
      }
    }
    return ExecutionInstruction.continueExecution;
  }
}
