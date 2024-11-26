import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
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
  quill.QuillController? _controller;

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  void fetchNote() async {
    final box = await Hive.openBox<Note>('notesBox');

    final note = box.values.firstWhere(
      (note) => note.topicId == widget.topicId,
    );

    final document = quill.Document.fromJson(
      note.notes.map((content) {
        return {
          'insert': content.insert,
          if (content.attributes != null) 'attributes': content.attributes,
        };
      }).toList(),
    );

    setState(() {
      _controller = quill.QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Notes'),
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: quill.QuillEditor(
                  controller: _controller!,
                  configurations: const quill.QuillEditorConfigurations(
                    autoFocus: false,
                    expands: false,
                    padding: EdgeInsets.zero,
                    scrollable: true,
                    embedBuilders: [],
                  ),
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                ),
              ),
            ),
    );
  }

  Widget _customEmbedBuilder(BuildContext context, quill.Embed embed) {
    if (embed.value.type == 'image') {
      final imageUrl = embed.value.data;
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return Container();
  }
}
