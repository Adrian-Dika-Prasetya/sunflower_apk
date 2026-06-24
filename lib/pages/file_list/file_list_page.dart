import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../models/file_model.dart';
import 'widgets/list_layout.dart';
import 'widgets/grid_layout.dart';

class FileListPage extends StatefulWidget {
  final String folderId;
  final String folderName;
  const FileListPage({super.key, required this.folderId, required this.folderName});

  @override
  State<FileListPage> createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  final Box<FileModel> fileBox = Hive.box<FileModel>('fileBox');

  Future<void> _pilihDanSimpanFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.single.path != null) {
        String pathAsli = result.files.single.path!;
        String namaAsliFile = result.files.single.name;
        String ekstensi = result.files.single.extension ?? 'unknown';

        final TextEditingController _namaKustomController = TextEditingController(text: namaAsliFile.split('.').first);
        final TextEditingController _notesController = TextEditingController();

        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Detail File Baru'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _namaKustomController, decoration: const InputDecoration(labelText: 'Nama File')),
                TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'Catatan'), maxLines: 2),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
              ElevatedButton(
                onPressed: () async {
                  if (_namaKustomController.text.trim().isNotEmpty) {
                    Directory appDir = await getApplicationDocumentsDirectory();
                    String idUnik = DateTime.now().millisecondsSinceEpoch.toString();
                    String pathBaru = '${appDir.path}/${idUnik}_$namaAsliFile';

                    await File(pathAsli).copy(pathBaru);
                    await fileBox.put(idUnik, FileModel(
                      id: idUnik,
                      name: _namaKustomController.text.trim(),
                      actualFileName: namaAsliFile,
                      path: pathBaru,
                      notes: _notesController.text.trim(),
                      folderId: widget.folderId,
                      fileType: ekstensi,
                    ));
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  void _bukaFileAsli(String pathFile) async {
    final result = await OpenFilex.open(pathFile);
    if (result.type != ResultType.done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${result.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folderName), backgroundColor: Colors.amber),
      body: ValueListenableBuilder(
        valueListenable: fileBox.listenable(),
        builder: (context, Box<FileModel> box, _) {
          final List<FileModel> daftarFile = box.values.where((file) => file.folderId == widget.folderId).toList();

          if (daftarFile.isEmpty) {
            return const Center(child: Text('Folder ini kosong.\nKlik + untuk mengupload!', textAlign: TextAlign.center));
          }

          bool apakahFolderGambar = ['jpg', 'jpeg', 'png'].contains(daftarFile.first.fileType.toLowerCase());

          // Panggil widget layout terpisah secara bersih
          return apakahFolderGambar
              ? GridLayout(daftarFile: daftarFile, fileBox: fileBox, onBukaFile: _bukaFileAsli)
              : ListLayout(daftarFile: daftarFile, fileBox: fileBox, onBukaFile: _bukaFileAsli);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pilihDanSimpanFile,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}