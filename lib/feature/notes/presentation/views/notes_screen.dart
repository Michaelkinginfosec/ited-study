import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:hive/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/model/notes.dart';

class NotesScreen extends StatefulWidget {
  final String topicId;

  const NotesScreen({required this.topicId, super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  void fetchNote() async {
    final box = Hive.box<Note>('notesBox');
    final notes = box.values.toList();

    final note = notes.firstWhere(
      (note) => note.topicId == widget.topicId,
    );

    final document = Document.fromJson(
      note.notes.map((content) {
        return {
          'insert': content.insert,
          if (content.attributes != null) 'attributes': content.attributes,
        };
      }).toList(),
    );

    setState(() {
      _controller = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  /// Custom embed builder for handling 'image' embed types.
  Widget customEmbedBuilder(BuildContext context, Embed node, bool readOnly) {
    if (node.value.type == 'image') {
      final imageUrl = node.value.data;
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return const SizedBox.shrink(); // Fallback for unsupported embed types
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notes'),
      ),
      body: _controller == null
          ? const Center(
              child: Text("No notes available"),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuillEditor(
                controller: _controller!,
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                configurations: QuillEditorConfigurations(
                  scrollable: true,
                  autoFocus: false,
                  padding: EdgeInsets.zero,
                  expands: false,
                  embedBuilders: FlutterQuillEmbeds.editorBuilders(
                    imageEmbedConfigurations:
                        QuillEditorImageEmbedConfigurations(
                      imageProviderBuilder: (context, imageUrl) {
                        if (imageUrl.startsWith('https://')) {
                          return NetworkImage(
                            imageUrl,
                          );
                        }
                        return NetworkImage(imageUrl);
                      },
                    ),
                  ),
                  customStyles: const DefaultStyles(),
                ),
              ),
            ),
    );
  }
}
