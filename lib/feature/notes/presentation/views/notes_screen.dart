import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ited_study/feature/notes/domain/model/notes.dart';

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

    try {
      final note = notes.firstWhere(
        (note) => note.topicId == widget.topicId,
      );

      final List<dynamic> deltaJson = note.notes.map((content) {
        dynamic insertValue;
        try {
          insertValue = jsonDecode(content.insert);
        } catch (e) {
          insertValue = content.insert;
        }

        return {
          'insert': insertValue,
          if (content.attributes != null) 'attributes': content.attributes,
        };
      }).toList();

      final document = Document.fromJson(deltaJson);

      setState(() {
        _controller = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    } catch (e) {
      debugPrint('Error loading note: $e');
      setState(() {
        _controller = QuillController.basic();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('View Notes'),
      ),
      body: _controller == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: QuillEditor(
                      controller: _controller!,
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                      config: QuillEditorConfig(
                        scrollable: true,
                        autoFocus: false,
                        padding: const EdgeInsets.all(8),
                        embedBuilders: [
                          ...FlutterQuillEmbeds.editorBuilders(),
                          QuillCustomEmbedBuilder(
                            builder: (context, node, isReadOnly) {
                              final imageUrl = node.value.data as String;
                              if (imageUrl
                                  .startsWith('https://res.cloudinary.com')) {
                                return SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.error),
                                          Text('Error loading image: $error'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                        customStyles: const DefaultStyles(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class QuillCustomEmbedBuilder extends EmbedBuilder {
  QuillCustomEmbedBuilder({required this.builder});

  final Widget Function(BuildContext context, Embed node, bool readOnly)
      builder;

  @override
  String get key => 'image';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    var node = embedContext.node;
    return builder(context, node, embedContext.readOnly);
  }
}
