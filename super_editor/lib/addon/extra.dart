// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:super_editor/super_editor.dart';

enum NoteStyles { header, bullet, image, empty, mixed }

/// Adds a [EditorRequest] to convert selected nodes to a specific style.
class ConvertSelectedNodesToSpecificStyleRequest implements EditorRequest {
  ConvertSelectedNodesToSpecificStyleRequest({
    required this.style,
  });
  final NoteStyles style;
}

class ConvertSelectedNodesToSpecificStyleCommand implements EditorCommand {
  final NoteStyles style;
  ConvertSelectedNodesToSpecificStyleCommand({
    required this.style,
  });

  @override
  List<DocumentChangeEvent> execute(EditorContext context) {
    final document = context.find<MutableDocument>('document');
    final composer = context.find<DocumentComposer>('composer');

    final selection = composer.selectionComponent.selection;
    if (selection == null) return [];

    final nodes = document.getNodesInContentOrder(selection);
    final removedNodes = <String>[];
    final addedNodes = <String>[];
    for (final node in nodes) {
      var text = AttributedText();
      if (node is TextNode) {
        text = node.text;
      }

      late DocumentNode newNode;
      switch (style) {
        case NoteStyles.bullet:
          newNode = ListItemNode.unordered(id: DocumentEditor.createNodeId(), text: text);
          break;
        case NoteStyles.header:
          newNode =
              ParagraphNode(id: DocumentEditor.createNodeId(), text: text, metadata: {'blockType': header1Attribution});
          break;
        case NoteStyles.image:
          // newNode = ImageListItemNode(
          //   id: DocumentEditor.createNodeId(),
          //   text: text,
          // );
          break;
        default:
          break;
      }

      if (!identical(node, newNode)) {
        document.replaceNode(oldNode: node, newNode: newNode);
        removedNodes.add(node.id);
        addedNodes.add(newNode.id);
      }
    }

    if (addedNodes.isNotEmpty) {
      composer.selectionComponent.updateSelection(
        selection.copyWith(
          base: selection.base.copyWith(
            nodeId: addedNodes.first,
          ),
          extent: selection.extent.copyWith(
            nodeId: addedNodes.last,
          ),
        ),
        notifyListeners: true,
      );
    }

    return [
      for (final id in removedNodes) NodeRemovedEvent(id),
      for (final id in addedNodes) NodeInsertedEvent(id),
    ];
  }
}




//  void replaceCurrentNodeFromNotesStyles(NoteStyles style) {
//     if (composer.selectionComponent.selection == null) return;
//     // ignore: no_leading_underscores_for_local_identifiers
//     final _selectedNodes = selectedNodes;
//     if (_selectedNodes.isEmpty) return;

//     final selection = composer.selectionComponent.selection!;

//     int? firstNodeIndex;
//     int? lastNodeIndex;

//     for (final node in _selectedNodes) {
//       var text = AttributedText();
//       if (node is TextNode) {
//         text = node.text;
//       }

//       late final DocumentNode newNode;
//       switch (style) {
//         case NoteStyles.bullet:
//           newNode = ListItemNode.unordered(id: DocumentEditor.createNodeId(), text: text);
//           break;
//         case NoteStyles.checkbox:
//           newNode = TaskNode(
//             id: DocumentEditor.createNodeId(),
//             text: text,
//             isComplete: false,
//           );
//           break;
//         case NoteStyles.image:
//           newNode = ImageListItemNode(
//             id: DocumentEditor.createNodeId(),
//             text: text,
//           );
//           break;
//         case NoteStyles.header:
//         case NoteStyles.empty:
//         case NoteStyles.mixed:
//           newNode = ParagraphNode(id: DocumentEditor.createNodeId(), text: text, metadata: {'blockType': header1Attribution});
//       }

//       firstNodeIndex ??= doc.getNodeIndexById(node.id);
//       lastNodeIndex = doc.getNodeIndexById(node.id);

//       if (!identical(node, newNode)) {
//         doc.replaceNode(oldNode: node, newNode: newNode);
//       }
//     }

//     composer.selectionComponent.updateSelection(
//       selection.copyWith(
//         base: selection.base.copyWith(nodeId: doc.nodes[firstNodeIndex!].id),
//         extent: selection.extent.copyWith(nodeId: doc.nodes[lastNodeIndex!].id),
//       ),
//     );
//   }
