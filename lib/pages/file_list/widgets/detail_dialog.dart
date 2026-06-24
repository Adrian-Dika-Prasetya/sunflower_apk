import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/file_model.dart';

class DetailDialog {
  static void tampilkan({
    required BuildContext context,
    required FileModel file,
    required Box<FileModel> fileBox,
    required Function(String) onBukaFile,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        bool apakahGambar = ['jpg', 'jpeg', 'png'].contains(file.fileType.toLowerCase());

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.85,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (apakahGambar) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(file.path),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(file.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'File asli: ${file.actualFileName}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(height: 20),
                  const Text('Catatan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber)),
                  const SizedBox(height: 4),
                  Text(file.notes.isEmpty ? 'Tidak ada catatan tambahan.' : file.notes, style: const TextStyle(fontSize: 14, height: 1.4)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _hapusFileDialog(context, file, fileBox, dialogContext),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editFileDialog(context, file, fileBox, dialogContext),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => onBukaFile(file.path),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, elevation: 0),
                        icon: const Icon(Icons.remove_red_eye, size: 16, color: Colors.black),
                        label: const Text('Buka', style: TextStyle(color: Colors.black, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void _editFileDialog(BuildContext context, FileModel file, Box<FileModel> fileBox, BuildContext dialogContext) {
    final TextEditingController _editNamaController = TextEditingController(text: file.name);
    final TextEditingController _editNotesController = TextEditingController(text: file.notes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Detail File'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _editNamaController, decoration: const InputDecoration(labelText: 'Nama File')),
              const SizedBox(height: 10),
              TextField(controller: _editNotesController, decoration: const InputDecoration(labelText: 'Catatan'), maxLines: 3),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (_editNamaController.text.trim().isNotEmpty) {
                  final fileBaru = FileModel(
                    id: file.id,
                    name: _editNamaController.text.trim(),
                    actualFileName: file.actualFileName,
                    path: file.path,
                    notes: _editNotesController.text.trim(),
                    folderId: file.folderId,
                    fileType: file.fileType,
                  );
                  await fileBox.put(file.id, fileBaru);
                  Navigator.pop(context);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  static void _hapusFileDialog(BuildContext context, FileModel file, Box<FileModel> fileBox, BuildContext dialogContext) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus File?'),
          content: Text('Apakah kamu yakin ingin menghapus "${file.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                try {
                  final fileFisik = File(file.path);
                  if (await fileFisik.exists()) await fileFisik.delete();
                } catch (_) {}
                await fileBox.delete(file.id);
                Navigator.pop(context);
                Navigator.pop(dialogContext);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}